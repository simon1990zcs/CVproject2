clear;
corner = 40 * ones(5, 5);
test_corner = zeros(10, 10);
test_corner(6 : 10, 6 : 10) = corner;

%get R matrix
[Ex2Sum, Ey2Sum, ExEySum, Eo] = getSumMatrix(test_corner);
R = getRmatrix(Ex2Sum, Ey2Sum, ExEySum);

%threshold R matrix
threshold = 1.0e9;
cornerMask = uint8(R > threshold);
% edgeMask = uint8(R < -threshold);
% mask = cornerMask + edgeMask;

%Thresholded mask
filtered_R = R .* double(cornerMask);
filtered_R = nonmax_suppression(filtered_R, Eo);
cornerMask2 = uint8(filtered_R > threshold);