
clear;
%read the images 
imageSet = 3;
[imgs, imgs_corlor] = getImgs(imageSet);

%get R matrix
[Ex2Sum, Ey2Sum, ExEySum, Eo] = getSumMatrix(imgs);
R = getRmatrix(Ex2Sum, Ey2Sum, ExEySum);

%threshold R matrix
threshold_R = 1.0e9;
cornerMask = uint8(R > threshold_R);
edgeMask = uint8(R < -threshold_R);
mask = cornerMask + edgeMask;

%Thresholded mask
filtered_R = R .* double(cornerMask);
suppressed_R = nonmax_suppression(filtered_R, Eo);
cornerMask2 = uint8(suppressed_R > threshold_R);


%loop around all image, and calculate all tranform matrix first
TFM = zeros(3, 3, size(imgs, 3));
TFM(:,:,1) = eye(3,3);

for i = 1 : size(imgs, 3) - 1
    %find corner correspondence according NCC algorithms
    [corner1, corner2] = findPairsOfCorners(imgs(:,:,i), imgs(:,:,i + 1), cornerMask2(:,:,i), cornerMask2(:,:,i + 1), 7);
    
        % display1: display the point matching between two images.
    points1 = cornerPoints(fliplr(corner1));
    points2 = cornerPoints(fliplr(corner2));
    figure;
    step = round(size(points1, 1) / 100);
    showMatchedFeatures(uint8(imgs_corlor(:,:,:,i)), uint8(imgs_corlor(:,:,:,i + 1)), points1(1:step:size(points1, 1)), points2(1:step:size(points1, 1)), 'montage');
    
    %RANSAC to filter out outliers, and find out best transform matrix
    threshold_Mathing = 100;
    for k = 1 : 4
        BestTFM = getTransformMatrix(corner1, corner2, threshold_Mathing);
        [corner1, corner2] = filterOutlier(corner1, corner2, BestTFM, threshold_Mathing);
        threshold_Mathing = threshold_Mathing / 2;
    end
    
    % display1: display the point matching between two images.
    points1 = cornerPoints(fliplr(corner1));
    points2 = cornerPoints(fliplr(corner2));
    figure;
    step = round(size(points1, 1) / 100);
    showMatchedFeatures(uint8(imgs_corlor(:,:,:,i)), uint8(imgs_corlor(:,:,:,i + 1)), points1(1:step:size(points1, 1)), points2(1:step:size(points1, 1)), 'montage');
    
    %using current tranform matrix, multiply previous tranform matrix to
    %get overall transform matrix to first img
    TFM(:,:, i + 1) = TFM(:,:,i) * BestTFM; 
end

%calculate the canvas size
[TFM2, height, width] = getFinalMeshAndNewTFM(TFM, imgs);



%warp images one by one to the canvas
[xi, yi] = meshgrid(1 : width, 1 : height);
img_warped = zeros(height, width, 3);
for i = 1 : size(imgs, 3)
    h = TFM2(:,:,i);
    %warp the current image
    xx = (h(2,1) * yi + h(2,2) * xi + h(2, 3)) ./ (h(3, 1) * yi + h(3, 2) * xi + h(3, 3));
    yy = (h(1,1) * yi + h(1,2) * xi + h(1, 3)) ./ (h(3, 1) * yi + h(3, 2) * xi + h(3, 3)); 
    imgi_warped = zeros(height, width, 3);
    for j = 1 : 3
        imgi_warped(:,:,j) = interp2(imgs_corlor(:,:,j,i), xx, yy);
    end
    
    %blend images together
    %blend1: using max
%     img_warped = max(img_warped, imgi_warped);
    %blend2: using averaging
    temp = img_warped > 0 & imgi_warped > 0;
    img_warped(temp) = (img_warped(temp) + imgi_warped(temp)) / 2;
    temp = img_warped == 0 & imgi_warped > 0;
    img_warped(temp) = imgi_warped(temp);
end

%display 3: fully warped image
imtool(uint8(img_warped));
% res = imfuse(img1_warped, img2_warped, 'blend','Scaling', 'joint');
