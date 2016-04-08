% noise estimation
function variance = noise_est(imgs)
variances = zeros(9,9);
for i = 4 : 12
    for j = 4 : 12
        variances(i,j) = var(imgs(i,j,:));
    end
end
variance = mean(mean(variances));
end