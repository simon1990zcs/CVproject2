%calculate Ex2, Ey2, ExEy sum matrix based on imgs.
function [Ex2Sum, Ey2Sum, ExEySum, Eo] = getSumMatrix(imgs)
    [row, col, max] = size(imgs);
    
    %intialize matrix
    Ex = zeros(row, col, max);
    Ey = zeros(row, col, max);
    Eo = zeros(row, col, max);
    Ex2Sum = zeros(row, col, max);
    Ey2Sum = zeros(row, col, max);
    ExEySum = zeros(row, col, max);
    
    %Prewitt mask
    px = [-1, 0 , 1; -1, 0 , 1; -1, 0 , 1];
    py = [-1, -1, -1; 0, 0, 0; 1, 1, 1];
    
    %apply prewitt mask to imgs
    for i = 1 : max
        Ex(:,:,i) = imfilter(imgs(:,:,i), px, 'replicate');
        Ey(:,:,i) = imfilter(imgs(:,:,i), py, 'replicate'); 
        [~, Eo(:, : , i)] = imgradient(Ex(:,:,i), Ey(:,:,i));
        Eo(:, : , i) = Eo(:, : , i) * -1;
    end
    
    %get Ex2, Ey2, and ExEy
    Ex2 = Ex .* Ex;
    Ey2 = Ey .* Ey;
    ExEy = Ex .* Ey;
    
    %preprocess sum matrix
    Ex2Sum(1, 1, :) = Ex2(1,1,:);
    Ey2Sum(1, 1, :) = Ey2(1,1,:);
    ExEySum(1, 1, :) = ExEy(1,1,:);

    for j = 2 : row
        Ex2Sum(j, 1, :) = Ex2Sum(j - 1, 1, :) + Ex2(j, 1, :);
        Ey2Sum(j, 1, :) = Ey2Sum(j - 1, 1, :) + Ey2(j, 1, :);
        ExEySum(j, 1, :) = ExEySum(j - 1, 1, :) + ExEy(j, 1, :);
    end
    for j = 2 : col
        Ex2Sum(1, j, :) = Ex2Sum(1, j - 1, :) + Ex2(1, j, :);
        Ey2Sum(1, j, :) = Ey2Sum(1, j - 1, :) + Ey2(1, j, :);
        ExEySum(1, j, :) = ExEySum(1, j - 1, :) + ExEy(1, j, :);
    end
    
    
    %claculate sum matrix
    for i = 2 : row
        for j = 2 : col
            Ex2Sum(i, j, :) = Ex2Sum(i - 1, j, :) + Ex2Sum(i, j - 1, :) - Ex2Sum(i - 1, j - 1, :) + Ex2(i, j, :);
            Ey2Sum(i, j, :) = Ey2Sum(i - 1, j, :) + Ey2Sum(i, j - 1, :) - Ey2Sum(i - 1, j - 1, :) + Ey2(i, j, :);
            ExEySum(i, j, :) = ExEySum(i - 1, j, :) + ExEySum(i, j - 1, :) - ExEySum(i - 1, j - 1, :) + ExEy(i, j, :);
        end
    end
    
end
        
    
    
    