function suppressed_R = nonmax_suppression(filtered_R, Eo)

D = [0, 45, 90, 135];
theta_Eo = Eo;
theta_Eo(theta_Eo < -22.5) = theta_Eo(theta_Eo < -22.5) + 180;
theta_Eo(theta_Eo > 157.5) = theta_Eo(theta_Eo > 157.5) - 180;

[row, col, max] = size(filtered_R);


for i = 3 : row - 2
    for j = 3 : col - 2
        for k = 1 : max
            if filtered_R(i, j, k) == 0
                continue;
            end
            min_diff = theta_Eo(i, j, k);
            min_theta = 0;
            
            for m = 1 : 4
                if abs(theta_Eo(i, j, k) - D(m)) < min_diff
                    min_theta = D(m);
                    min_diff = abs(theta_Eo(i, j, k) - D(m));
                end
            end
            % nonmax_suppression
            filtered_R = suppress(filtered_R, min_theta, i, j, k);
        end 
    end
end

suppressed_R = filtered_R;

end

function filtered_R = suppress(filtered_R, min_theta, row, col, k)

D = [0, 45, 90, 135];
deltaCol = [1, 1, 0, -1];
deltaRow = [0, 1, 1, 1];
times = [-2, -1, 1, 2];
neigh = zeros(4, 2);

for m = 1 : 4
    if min_theta == D(m)
        for n = 1 : 4
            neigh(n, 1) = row + deltaRow(m) * times(n);
            neigh(n, 2) = col + deltaCol(m) * times(n);
        end
        break;
    end
end

for m = 1 : 4
    if filtered_R(row, col, k) < filtered_R(neigh(m, 1), neigh(m, 2), k);
        filtered_R(row, col, k) = 0;
        break;
    end
end


end