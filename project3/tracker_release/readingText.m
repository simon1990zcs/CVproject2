function [positions, target_sz_MIL] = readingText(filePath)
fileID = fopen(filePath);
C = textscan(fileID, '%f %f %f %f', 'Delimiter', ',');
row = C{1};
col = C{2};
positions = [row, col];
width = C{3};
height = C{4};
target_sz_MIL = [height(1) width(1)];
end
