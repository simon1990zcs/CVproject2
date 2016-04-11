function show_precision_own(positions, ground_truth, title, figNum)
max_threshold = 50;  %used for graphs in the pape
color_line = ['k-', 'r*', 'b.'];
method = ['CM', 'CM_occlusion', 'MIL'];
	if size(positions,1) ~= size(ground_truth,1),
		disp('Could not plot precisions, because the number of ground')
		disp('truth frames does not match the number of tracked frames.')
		return
	end
	
	%calculate distances to ground truth over all frames
	distances = sqrt((positions(:,1) - ground_truth(:,1)).^2 + ...
				 	 (positions(:,2) - ground_truth(:,2)).^2);
	distances(isnan(distances)) = [];

	%compute precisions
	precisions = zeros(max_threshold, 1);
	for p = 1:max_threshold,
		precisions(p) = nnz(distances < p) / numel(distances);
	end
	
	%plot the precisions
	figure(1)
	plot(precisions, color_line(figNum), 'LineWidth',2)
    
	xlabel('Threshold'), ylabel('Precision')
    hold on
end