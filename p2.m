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


%display 
row = size(imgs, 1);
col = size(imgs, 2);

sample1 = zeros(row, col);
sample2 = zeros(row, col);
for i = 1 : row
    for j = 1 : col
        sample1(i, j) = imgs(i, j, 1) * (1 + cornerMask2(i, j, 1));
        sample2(i, j) = imgs(i, j, 1) * (1 + cornerMask(i, j, 1));
    end
end

imtool(sample1, [0,255]);
imtool(sample2, [0,255]);

