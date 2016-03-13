function BestTFM = getTransformMatrix(corner1, corner2, threshold)
%based one two corner correspondence set, and a threshold to check if two points are match, 
% to find out a best Transform Matrix

BestMatch = 0;
BestTFM = zeros(3, 3);

%loop 20 time, find best hight match NO, and pick that transform 
for i = 1 : 30
    %pick random 4 points
    len = size(corner1, 1);
    fourPs = round(rand(1, 4) * (len - 1)) + 1;
    [transform, match] = RANSAC(corner1, corner2, fourPs, threshold);
    if match > BestMatch
        BestMatch = match;
        BestTFM = transform;
    end
end

end

function [transform, match] = RANSAC(corner1, corner2, fourPs, threshold)
match = 0;

%get transform Matrix based on four points
transform = getTFbyRANSAC(corner1, corner2, fourPs);

%apply the M to all points, find out how many points matches
for i = 1 : size(corner1, 1)
   response = transform * [corner1(i, :), 1]';
   response = response / response(3); % make the response to [x, y, 1]
   diff = sum(abs(response(1:2)' - corner2(i, :)));
   %diff = pow(response(1) - corner2(i,1), 2) + pow(response(2) - corner2(i,2), 2);
   if diff < threshold 
       match = match + 1;
   end
end

end

function transform = getTFbyRANSAC(corner1, corner2, fourPs)
A = zeros(8, 8);
for i = 1 : 4
    r = i * 2 - 1;
    A(r, 1:3) = [corner1(fourPs(i), :),1];
    A(r, 7:8) = corner1(fourPs(i), :) * -corner2(fourPs(i), 1);
    r = i * 2;
    A(r, 4:6) = [corner1(fourPs(i), :),1];
    A(r, 7:8) = corner1(fourPs(i), :) * -corner2(fourPs(i), 2);
end

b = [corner2(fourPs(1), :)';corner2(fourPs(2), :)';corner2(fourPs(3), :)';corner2(fourPs(4), :)'];

h = A \ b;
%convert h transform M
transform(1, :) = h(1:3)';
transform(2, :) = h(4:6)';
transform(3, 1:2) = h(7:8)';
transform(3,3) = 1;

end