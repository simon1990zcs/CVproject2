%return a imgs matrix, based on image set NO.
function imgs = getImgs(imageSet)
    row = 340;
    col = 512;
    
    if imageSet == 1
        folderPath = './HallWay1/DSC_%04d.jpg';
        initial = 281;
        max = 3;
    elseif imageSet == 2  
        folderPath = './HallWay2/DSC_%04d.jpg';
        initial = 285;
        max = 3;
    elseif imageSet == 3
        folderPath = './Office/DSC_%04d.jpg';
        initial = 309;
        max = 5;
    end
    
    imgs = zeros(row, col, max);
    
    for i = 1 : max
        %generate jpg files name according to sequence
        jpgFileName = sprintf(folderPath, initial + i - 1);
    
        %read the image and make them grayscale
        if exist(jpgFileName, 'file')
        	imageData = imread(jpgFileName, 'jpg');
            imgs(:,:,i) = rgb2gray(imageData);
        else
        	fprintf('File %s does not exist.\n', jpgFileName);
        end
    end
end