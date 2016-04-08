%Section a: environmental setup for 3 different sets of images
imageset = 1;

row = 240;
col = 320;
initial = 1;

if imageset == 1
    folderPath = './Office/img01_%04d.jpg';
    max = 500;
    screenshot = 130;
elseif imageset == 2
    folderPath = './CrossingPaths/EnterExitCrossingPaths2cor%04d.jpg';
    max = 480;
    row = 288;
    col = 384;
    screenshot = 180;
else
    folderPath = './RedChair/advbgst1_21_%04d.jpg';
    max = 350;
    initial = 2;
    screenshot = 71;
end


%Section b: load images and make them grayscale into a 3D matrix 
imgs = zeros(row, col, max);
for  k = initial : max
    %generate jpg files name according to sequence
    jpgFileName = sprintf(folderPath, k);
    
    %read the image and make them grayscale
	if exist(jpgFileName, 'file')
		imageData = imread(jpgFileName, 'jpg');
        imgs(:,:,k) = rgb2gray(imageData);
	else
		fprintf('File %s does not exist.\n', jpgFileName);
    end
        
end

var0 = noise_est(imgs);
%section c: filter images with smoothing first 
box1 = ones(3,3) / 9;
box2 = ones(5,5) / 25;
gaussian2d = fspecial('gaussian', [5,5], 1);
for i = 1 : max
    imgs(:,:,k) = imfilter(imgs(:,:,k), box1, 'replicate');
end
var1 = noise_est(imgs);

%section d: compute temporal derivative
diffImgs = zeros(row,col, max);
%---default solution: 1D differential operator
diffImgs(:,:,2:max) = diff(imgs, 1, 3);
% %---simple 0.5[-1, 0, 1] filter
% filter1 = 0.5 * [-1, 0, 1];
% %---1D derivative of a gaussian filter
% gaussian = fspecial('gaussian', [1,7], 1.4);
% [filter2,] = gradient(gaussian);
% for i = 1 : row
%     for j = 1 : col
%         imageT = squeeze(imgs(i,j,:));
%         diffImgs(i, j, :) = imfilter(imageT, filter2', 'replicate');
%     end
% end
var2 = noise_est(imgs);

%section e: Threshold the absolute values of derivatives to create a mask
deviation = 2;
% deviation = sqrt(noise_est(imgs));
masks = abs(diffImgs) > 2 * deviation;
masks = uint8(masks);


%section f: apply the mask to original images, and loaded them to a movie
for k = initial : max
    jpgFileName = sprintf(folderPath, k);
    imageData = imread(jpgFileName, 'jpg');
    for i = 1 : 3
        temp(:,:,i) = imageData(:,:,i) .* masks(:,:,k);
    end
    frames(k) = im2frame(temp);
    %since the RedChair doesn't 0001 image, we copy the second frame as
    %first frame as well
    if initial == 2
        frames(1) = frames(2);
    end
end

%section g: display the masked movie
%movie(frames);
% imtool(originalImg);
imtool(frames(screenshot).cdata);