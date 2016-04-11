function pos = hankelMatrix2(hankelPos, Iend)

n = min(5, Iend);
hankelPos = hankelPos( Iend - (2 * n - 3): Iend, :);
pos = zeros(1, 2);

A = zeros(n - 1, (n -1));
b = zeros(n - 1, 1);
C = zeros(1, n - 1);

for cor = 1: 2
    for row = 1: n - 1
        for col = 1: n - 1
            index = row - 1 + col;
            A(row, col) = hankelPos(index,cor)';
        end
        
        index = row + n - 1;
        C(1, row) = hankelPos(index,cor)';
        b(row, 1) = hankelPos(index,cor)';
    end
    
    X = C * (A \ b);
    pos(1, cor) = X;
end

end