function [corner1, corner2] = findPairsOfCorners(image1, image2, R1, R2, win_size)



% num of corners in images(R1, R2)
[r1, c1] = find(R1);
[r2, c2] = find(R2);



corner1 = zeros(2,size(r1))';
corner2 = zeros(2,size(r1))';


for i = 1 : size(r1)
    cn1 = getWindow(image1, r1(i), c1(i), win_size);
    ncc = -1;
    corner1(i,:) = [r1(i), c1(i)];
    for j = 1 :size(r2)
        cn2 = getWindow(image2, r2(j), c2(j), win_size);
        temp_ncc = computeNCC(cn1, cn2);
        if ncc < temp_ncc
            ncc = temp_ncc;
            corner2(i,:) = [r2(j), c2(j)];
        end
    end
end

    

end

function cn = getWindow(image, row, col, win_size)
cn = image(row - (win_size - 1) / 2 : row + (win_size - 1) / 2,...
        col - (win_size - 1) / 2 : col - (win_size - 1) / 2);
end
