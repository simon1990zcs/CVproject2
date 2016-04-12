
base_path = '../girl';
video_path = choose_video(base_path);

[img_files, pos, target_sz, resize_image, ground_truth, video_path] = ...
	load_video_info(video_path);
file_CM = '../girl/girl_CM.txt';
file_MIL = '../girl/girl_MIL_TR001.txt';
file_own = '../girl/girl_own.txt';

[positions_CM, ~] = readingText(file_CM);
[positions_MIL, ~] = readingText(file_MIL);
[positions_own, ~] = readingText(file_own);



show_precision_own(positions_CM, ground_truth, file_CM, 1);

show_precision_own(positions_MIL, ground_truth, file_MIL, 2);

show_precision_own(positions_own, ground_truth, file_own, 3);

legend('CM', 'MIL', 'CM-occlusion')



