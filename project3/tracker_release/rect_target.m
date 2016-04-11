% function rect_target(video_path, filePath, positions, figNum)
base_path = '../tiger1';
video_path = choose_video(base_path);
figNum = 1;
file_CM = '../tiger1/tiger_CM.txt';
file_MIL = '../tiger1/tiger1_MIL_TR004.txt';
file_own = '../tiger1/tiger_own.txt';

[img_files, ~, target_sz, ~, ground_truth, ~] = ...
	load_video_info(video_path);

color = ['g', 'r', 'b'];
[positions_CM, ~] = readingText(file_CM);
[positions_MIL, ~] = readingText(file_MIL);
[positions_own, ~] = readingText(file_own);


for frame = 1 : numel(img_files)
    pos1 = positions_CM(frame, :);
    pos2 = positions_own(frame, :);
    pos3 = positions_MIL(frame, :);
    im = imread([video_path img_files{frame}]);
%visualization
	rect_position1 = [pos1([2,1]) - target_sz([2,1])/2, target_sz([2,1])];
    rect_position2 = [pos2([2,1]) - target_sz([2,1])/2, target_sz([2,1])];
    rect_position3 = [pos3([2,1]) - target_sz([2,1])/2, target_sz([2,1])];
	if frame == 1,  %first frame, create GUI
		figure(2)
		im_handle = imshow(im, 'Border','tight', 'InitialMag',200);
		rect_handle1 = rectangle('Position',rect_position1, 'EdgeColor',color(1));
        rect_handle2 = rectangle('Position',rect_position2, 'EdgeColor',color(2));
        rect_handle3 = rectangle('Position',rect_position3, 'EdgeColor',color(3));
	else
		try  %subsequent frames, update GUI
			set(im_handle, 'CData', im)
			set(rect_handle1, 'Position', rect_position1)         
            set(rect_handle2, 'Position', rect_position2) 
            set(rect_handle3, 'Position', rect_position3) 
		catch  %#ok, user has closed the window
			return
		end
	end
	
	drawnow
% 	pause(0.05)  %uncomment to run slower
end