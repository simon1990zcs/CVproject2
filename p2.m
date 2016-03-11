%read the images 
imageSet = 1;
imgs = getImgs(imageSet);

%get R matrix
[Ex2Sum, Ey2Sum, ExEySum, Eo] = getSumMatrix(imgs);
R = getRmatrix(Ex2Sum, Ey2Sum, ExEySum);

%threshold R matrix
threshold = 1.0e9;
cornerMask = uint8(R > threshold);
edgeMask = uint8(R < -threshold);
mask = cornerMask + edgeMask;

%Thresholded mask
filtered_R = R .* double(cornerMask);
suppressed_R = nonmax_suppression(filtered_R, Eo);
cornerMask2 = uint8(suppressed_R > threshold);

%Corner feature matching
[corner1, corner2] = findPairsOfCorners(imgs(:,:,1), imgs(:,:,2), cornerMask2(:,:,1), cornerMask2(:,:,2), 7);
points1 = cornerPoints(corner1);
points2 = cornerPoints(corner2);

image = imgs(:,:,1);
for i = 1 : size(corner2, 1)
    image(corner1(i, 1), corner1(i, 2)) = 255;
end

figure
% ax = axes;
showMatchedFeatures(imgs(:,:,1), imgs(:,:,1), points1, points1, 'montage');
% legend(ax, 'Matched points 1','Matched points 2');
figure
imshow(image,[]);



%display 
row = size(imgs, 1);
col = size(imgs, 2);

% sample1 = zeros(row, col);
% sample2 = zeros(row, col);
% for i = 1 : row
%     for j = 1 : col
%         sample1(i, j) = imgs(i, j, 3) * (1 + cornerMask2(i, j, 3));
%         sample2(i, j) = imgs(i, j, 3) * (1 + cornerMask(i, j, 3));
%     end
% end
% 
sample1 = imgs(:,:,1) .* (1 + double(cornerMask2(:,:,1)));
sample2 = imgs(:,:,2) .* (1 + double(cornerMask2(:,:,2)));
% 
% imtool(sample1, [0,255]);
% imtool(sample2, [0,255]);

