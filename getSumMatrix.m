%calculate Ex2, Ey2, ExEy sum matrix based on imgs.
function [Ex2Sum, Ey2Sum, ExEySum, Eo] = getSumMatrix(imgs)
    [row, col, max] = size(imgs);
%     row = size(imgs, 1);
%     col = size(imgs, 2);
%     max = size(imgs, 3);
    
    %intialize matrix
    Ex = zeros(row, col, max);
    Ey = zeros(row, col, max);
    Eo = zeros(row, col, max);
    Ex2 = zeros(row, col, max);
    Ey2 = zeros(row, col, max);
    ExEy = zeros(row, col, max);
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
    for i = 1 : max
        Ex2(:,:,i) = Ex(:,:,i) .* Ex(:,:,i);
        Ey2(:,:,i) = Ey(:,:,i) .* Ey(:,:,i);
        ExEy(:,:,i) = Ex(:,:,i) .* Ey(:,:,i);
    end
    
    %preprocess sum matrix
    for i = 1 : max
        Ex2Sum(1, 1, i) = Ex2(1,1,i);
        Ey2Sum(1, 1, i) = Ey2(1,1,i);
        ExEySum(1, 1, i) = ExEy(1,1,i);
        for j = 2 : row
            Ex2Sum(j, 1, i) = Ex2Sum(j - 1, 1, i) + Ex2(j, 1, i);
            Ey2Sum(j, 1, i) = Ey2Sum(j - 1, 1, i) + Ey2(j, 1, i);
            ExEySum(j, 1, i) = ExEySum(j - 1, 1, i) + ExEy(j, 1, i);
        end
        for j = 2 : col
            Ex2Sum(1, j, i) = Ex2Sum(1, j - 1, i) + Ex2(1, j, i);
            Ey2Sum(1, j, i) = Ey2Sum(1, j - 1, i) + Ey2(1, j, i);
            ExEySum(1, j, i) = ExEySum(1, j - 1, i) + ExEy(1, j, i);
        end
    end
    
    %claculate sum matrix
    for k = 1 : max
        for i = 2 : row
            for j = 2 : col
                Ex2Sum(i, j, k) = Ex2Sum(i - 1, j, k) + Ex2Sum(i, j - 1, k) - Ex2Sum(i - 1, j - 1, k) + Ex2(i, j, k);
                Ey2Sum(i, j, k) = Ey2Sum(i - 1, j, k) + Ey2Sum(i, j - 1, k) - Ey2Sum(i - 1, j - 1, k) + Ey2(i, j, k);
                ExEySum(i, j, k) = ExEySum(i - 1, j, k) + ExEySum(i, j - 1, k) - ExEySum(i - 1, j - 1, k) + ExEy(i, j, k);
            end
        end
    end
end
        
    
    
    