clear;
corner = 40 * ones(10, 10);
test_corner = zeros(20, 20);
test_corner(11 : 20, 11 : 20) = corner;

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
suppressed_R = nonmax_suppression(filtered_R, Eo);
cornerMask2 = uint8(suppressed_R > threshold);