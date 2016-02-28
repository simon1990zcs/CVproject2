function suppressed_R = nonmax_suppression(filtered_R, Eo)

D = [0, pi/4, pi/2, 3*pi/4];
theta_Eo = atan(Eo);
theta_Eo(theta_Eo < 0) = theta_Eo(theta_Eo < 0) + pi;

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
                if theta_Eo(i, j, k) - D(m) < min_diff
                    min_theta = D(m);
                end
            end
            % nonmax_suppression
            filtered_R = suppress(filtered_R, min_theta, i, j, k);
        end 
    end
end

suppressed_R = filtered_R;

end

function filtered_R = suppress(filtered_R, min_theta, i, j, k)

D = [0, pi/4, pi/2, 3*pi/4];
deltaX = [1, 1, 0, -1];
deltaY = [0, 1, 1, 1];
delta = [-2, -1, 1, 2];
neigh = zeros(4, 2);

for m = 1 : 4
    if min_theta == D(m)
        for n = 1 : 4
            neigh(n, 1) = i + deltaX(m) * delta(n);
            neigh(n, 2) = j + deltaY(m) * delta(n);
        end
        break;
    end
end

for m = 1 : 4
    if filtered_R(i, j, k) < filtered_R(neigh(m, 1), neigh(m, 2), k);
        filtered_R(i, j, k) = 0;
        break;
    end
end


end