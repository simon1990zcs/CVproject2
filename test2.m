im1 = rand(5);
im2 = ones(5,5);
im2(1:2, 1:2) = 0;

ncc = computeNCC(im1 ,im2);



