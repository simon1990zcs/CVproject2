function BestTFM = getTransformMatrix(corner1, corner2)

BestMatch = 0;
BestTFM = zeros(3, 3);

%loop 20 time, find best hight match NO, and pick that transform 
for i = 1 : 20
    %pick random 4 points
    len = size(corner1, 1);
    fourPs = Round(rand(1, 4) * len);
    [transform, match] = RANSAC(corner1, corner2, fourPs);
    if match > BestMatch
        BestMatch = match;
        BestTFM = transform;
    end
end

%to do: clean a group of outlier, then do RANSAC again

end

function [transform, match] = RANSAC(corner1, corner2, fourPs)
match = 0;

%get transform Matrix based on four points
transform = getTFbyRANSAC(corner1, corner2, fourPs);

%apply the M to all points, find out how many points matches
for i = 1 : size(corner1, 1)
   response = transform * [corner1(i), 1]';
   response = response / response(3);
   diff = pow(response(1) - corner2(i,1), 2) + pow(response(2) - corner2(i,2), 2);
   if diff < 10
       match = match + 1;
   end
end

end

function transform = getTFbyRANSAC(corner1, corner2, fourPs)
left = zeros(8, 8);
for i = 1 : 4
    r = i * 2 - 1;
    left(r, 1:3) = [corner1(fourPs(i)),1];
    left(r, 7:8) = corner1(fourPs(i)) * -corner2(fourPs(i), 1);
    r = i * 2;
    left(r, 4:6) = [corner1(fourPs(i)),1];
    left(r, 7:8) = corner1(fourPs(i)) * -corner2(fourPs(i), 2);
end

right = [fourPs(1)';fourPs(2)';fourPs(3)';fourPs(4)'];

h = left / right;
%convert h transform M
transform(1) = h(1:3)';
transform(2) = h(4:6)';
transform(3, 1:2) = h(7:8)';
end