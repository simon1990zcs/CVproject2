function pos = hankelMatrix(hankelPos, Iend)

n = min(5, floor(Iend / 2 + 1));
hankelPos = hankelPos( Iend - (2 * n - 3): Iend, :);
A = zeros(2 * (n - 1), (n -1));
b = zeros(2 * (n - 1), 1);
C = zeros(2, n - 1);

for row = 1: 2: 2 * (n - 1)
    for col = 1: n - 1
        index = (row - 1) / 2 + col;
        A(row:row+1, col) = hankelPos(index,:)';
    end
end

for i = 1 :n - 1
   index = i + n - 1;
   C(:, i) = hankelPos(index,:)';
   b(2 * i - 1: 2 * i, :) = hankelPos(index,:)';
end

v = A \ b;
X = C * v;
pos = X';

end 