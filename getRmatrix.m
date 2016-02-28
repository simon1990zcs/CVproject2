%calculate the R matrix based on Ex2, Ey2, ExEy sum matrix
function R = getRmatrix(Ex2Sum, Ey2Sum, ExEySum)
row = size(Ex2Sum, 1);
col = size(Ex2Sum, 2);
hgt = size(Ex2Sum, 3);
R = zeros(row, col, hgt);

for h = 1 : 1
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
k = 0.05;
r = det - k * trace * trace;
end


function c = getCmatrix(Ex2Sum, Ey2Sum, ExEySum, x, y, h)
c = zeros(2, 2);
c(1,1) = Ex2Sum(x + 3, y + 3, h) - Ex2Sum(x - 4, y + 3, h) - Ex2Sum(x + 3, y - 4, h) + Ex2Sum(x - 4, y - 4, h);
c(2,2) = Ey2Sum(x + 3, y + 3, h) - Ey2Sum(x - 4, y + 3, h) - Ey2Sum(x + 3, y - 4, h) + Ey2Sum(x - 4, y - 4, h);
c(1,2) = ExEySum(x + 3, y + 3, h) - ExEySum(x - 4, y + 3, h) - ExEySum(x + 3, y - 4, h) + ExEySum(x - 4, y - 4, h);
c(2,1) = c(1,2);
end
    
    