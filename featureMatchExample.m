clear;
I1 = rgb2gray(imread('./HallWay1/DSC_0281.JPG'));
I2 = rgb2gray(imread('./HallWay1/DSC_0282.JPG'));

points1 = detectHarrisFeatures(I1);
points2 = detectHarrisFeatures(I2);

[f1, vpts1] = extractFeatures(I1, points1);
[f2, vpts2] = extractFeatures(I2, points2);

indexPairs = matchFeatures(f1, f2) ;
matchedPoints1 = vpts1(indexPairs(1:15, 1));
matchedPoints2 = vpts2(indexPairs(1:15, 2));
cn1 = [10, 100; 15, 100; 50, 50];
cn2 = [10, 100; 15, 100; 50, 50];
tp1 = cornerPoints(cn1);
tp2 = cornerPoints(cn2);
% matchedPoints1 = [4,5;100,30;130,160;50,10];
% matchedPoints2 = [6,7;120,45;160,200;70,23];

figure; ax = axes;
showMatchedFeatures(I1,I2,tp1,tp2,'montage','Parent',ax);
title(ax, 'Candidate point matches');
legend(ax, 'Matched points 1','Matched points 2');