function [cn1, cn2] = filterOutlier(corner1, corner2, transform, threshold)
%filter out unmatch corner correspondence in corner set
index = 1;
for i = 1 : size(corner1, 1)
   response = transform * [corner1(i, :), 1]';
   response = response / response(3); % make the response to [x, y, 1]
   diff = sum(abs(response(1:2)' - corner2(i, :)));
    if diff < threshold
        cn1(index, :) = corner1(i, :);
        cn2(index, :) = corner2(i, :);
        index = index + 1;
    end
end

end