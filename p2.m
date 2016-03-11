%read the images 
imageSet = 1;
imgs = getImgs(imageSet);

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

%find corner correspondence according NCC algorithms
%TO DO: only detect two images first, after to spread to other images.
[corner1, corner2] = findPairsOfCorners(imgs(:,:,1), imgs(:,:,2), cornerMask2(:,:,1), cornerMask2(:,:,2), 7);

%RANSAC to filter out outliers
threshold_Mathing = 100;
for i = 1 : 4
    BestTFM = getTransformMatrix(corner1, corner2, threshold_Mathing);
    [corner1, corner2] = filterOutlier(corner1, corner2, BestTFM, threshold_Mathing);
    threshold_Mathing = threshold_Mathing / 2;
end

%display1: display the point matching between two images.
points1 = cornerPoints(corner1);
points2 = cornerPoints(corner2);

image = imgs(:,:,1);
for i = 1 : size(corner2, 1)
    image(corner1(i, 1), corner1(i, 2)) = 255;
end

figure
% ax = axes;
showMatchedFeatures(imgs(:,:,1), imgs(:,:,2), points1, points2, 'montage');
% legend(ax, 'Matched points 1','Matched points 2');

%display2: first two images, with corners highlighted
sample1 = imgs(:,:,1) .* (1 + double(cornerMask2(:,:,1)));
sample2 = imgs(:,:,2) .* (1 + double(cornerMask2(:,:,2)));
imtool(sample1, [0,255]);
imtool(sample2, [0,255]);

