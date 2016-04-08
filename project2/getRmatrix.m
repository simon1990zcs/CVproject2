%calculate the R matrix based on Ex2, Ey2, ExEy sum matrix
function R = getRmatrix(Ex2Sum, Ey2Sum, ExEySum)
[row, col, hgt] = size(Ex2Sum);
R = zeros(row, col, hgt);

for h = 1 : hgt
    for x = 5 : row - 3
        for y = 5 : col - 3
            R(x,y,h) = getRvalue(Ex2Sum, Ey2Sum, ExEySum, x, y, h);
        end
    end
end


end


function r = getRvalue(Ex2Sum, Ey2Sum, ExEySum, x, y, h)
%get c matrix first
c = getCmatrix(Ex2Sum, Ey2Sum, ExEySum, x, y, h);

%get r value
det = c(1,1) * c(2, 2) - c(1,2) * c(2,1);
trace = c(1,1) + c(2,2);
k = 0.04;
r = det - k * trace * trace;
end


function c = getCmatrix(Ex2Sum, Ey2Sum, ExEySum, x, y, h)
% using N * N window matrix to get C matrix, 
N = 5;
n = (N - 1) / 2;
c = zeros(2, 2);
c(1,1) = Ex2Sum(x + n, y + n, h) - Ex2Sum(x - n - 1, y + n, h) - Ex2Sum(x + n, y - n - 1, h) + Ex2Sum(x - n - 1, y - n - 1, h);
c(2,2) = Ey2Sum(x + n, y + n, h) - Ey2Sum(x - n - 1, y + n, h) - Ey2Sum(x + n, y - n - 1, h) + Ey2Sum(x - n - 1, y - n - 1, h);
c(1,2) = ExEySum(x + n, y + n, h) - ExEySum(x - n - 1, y + n, h) - ExEySum(x + n, y - n - 1, h) + ExEySum(x - n - 1, y - n - 1, h);
c(2,1) = c(1,2);
end
    
    