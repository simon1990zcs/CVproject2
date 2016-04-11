function PSR = getPSR(response, sidelobe)

%hide 11*11 matrix around [row,col]
gmax = max(response(:));
[row, col] = find(response == gmax, 1);

%set area around peak to 0
temp = (sidelobe - 1) / 2;
lt = max(1, row - temp);
lb = min(size(response,1), row + temp);
rt = max(1, col - temp);
rb = min(size(response, 2), row + temp);
response(lt:lb, rt:rb) = zeros(lb - lt + 1,rb - rt + 1);

%calculate the rest area
reconstructedRs = response(response~=0);
meanValue = mean(reconstructedRs);
sigmaValue = sqrt(var(reconstructedRs));
PSR = (gmax - meanValue)/sigmaValue;

end