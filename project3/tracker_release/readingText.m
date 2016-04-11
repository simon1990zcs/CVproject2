function [positions, width, height] = readingText(filePath)
filePath = './tiger1/tiger1_MIL_TR001.txt';
fileID = fopen(filePath);
C = textscan(fileID, '%f %f %f %f', 'Delimiter', ',');
row = C{1};
col = C{2};
positions = [row, col];
width = C{3};
height = C{4};

