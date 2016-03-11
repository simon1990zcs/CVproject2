function [corner1, corner2] = findPairsOfCorners(image1, image2, R1, R2, win_size)
% R1 and R2 are the corners after non_maximum suppression
% 


% num of corners in images(R1, R2)
% find non-zero elements of R1 and R2, which are the indices of the corners
[r1, c1] = find(R1);
[r2, c2] = find(R2);



corner1 = zeros(size(r1, 1), 2);
corner2 = zeros(size(r1, 1), 2);


for i = 1 : size(r1, 1)
    
    cn1 = getWindow(image1, r1(i), c1(i), win_size);
    if cn1 == zeros(win_size, win_size)
        continue;
    end
    ncc = -1;
    corner1(i,:) = [r1(i), c1(i)];
    for j = 1 :size(r2, 1)
        cn2 = getWindow(image2, r2(j), c2(j), win_size);
        if cn2 == zeros(win_size, win_size)
            continue;
        end
            temp_ncc = computeNCC(cn1, cn2);
        if ncc < temp_ncc
            ncc = temp_ncc;
            corner2(i,:) = [r2(j), c2(j)];
        end
    end
end

    

end

function cn = getWindow(image, row, col, win_size)
if (row - (win_size - 1) / 2 > 0) && (row + (win_size - 1) / 2 <= size(image,1)...
        && col - (win_size - 1) / 2 > 0 && col + (win_size - 1) / 2 <= size(image,2))
    
    cn = image(row - (win_size - 1) / 2 : row + (win_size - 1) / 2,...
        col - (win_size - 1) / 2 : col + (win_size - 1) / 2);
else 
    cn = zeros(win_size, win_size);
end
end
