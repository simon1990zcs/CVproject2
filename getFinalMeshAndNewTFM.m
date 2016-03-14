function [TFM2, height, width] = getFinalMeshAndNewTFM(TFM, imgs)
%based on all transform matrix, get calculate overall boundary for all
%images, return new transform matrix and height and width of mesh grid

[row, col, hgt] = size(imgs);

%calculate the canvas size
boundary = zeros(1, 4); %up, down, left, right
cnpoint = ones(4, 2);
cnpoint(2, :) = [row, 1];
cnpoint(3, :) = [1, col];
cnpoint(4, :) = [row, col];
for i = 1 : hgt
    for j = 1 : 4
        response = TFM(:, :, i) \ [cnpoint(j, :) , 1]';
        response = response ./ response(3);
        boundary(1) = min(boundary(1), response(1));
        boundary(2) = max(boundary(2), response(1));
        boundary(3) = min(boundary(3), response(2));
        boundary(4) = max(boundary(4), response(2));
    end
end

boundary = ceil(boundary);
height = boundary(2) - boundary(1);
width = boundary(4) - boundary(3);

%get new tranform matrix
baseMatrix = eye(3,3);
baseMatrix(1:2,3) = [boundary(1); boundary(3)];
TFM2 = zeros(3, 3, hgt);
for i = 1 : hgt
    TFM2(:,:,i) = TFM(:,:,i) * baseMatrix;
end

end