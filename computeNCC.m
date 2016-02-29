function NCC = computeNCC(corner1, corner2)

mean1 = mean(mean(corner1));
corner1 = corner1 - mean1;
var1 = sqrt(sum(corner1(:) .^ 2));
corner1 = corner1 / var1;git 

mean2 = mean(mean(corner2));
corner2 = corner2 - mean2;
var2 = sqrt(sum(corner2(:) .^ 2));
corner2 = corner2 / var2;

correlation = corner1 .* corner2;
NCC = sum(correlation(:));

end