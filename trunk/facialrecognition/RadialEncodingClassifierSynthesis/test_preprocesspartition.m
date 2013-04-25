%% test PreprocessPartition.m
clear all;
close all;


%% test preprocess
fid = fopen('.\test_fun_pic\test1_name.txt');
facial_name_cell = textscan(fid, '%s');
for i = 1 : length(facial_name_cell{1, 1})
    %fprintf('%s', cell2mat(facial_name_cell{1, 1}(i)));
    facial_image = imread(['.\test_fun_pic\', cell2mat(facial_name_cell{1, 1}(i))]);
    [height, width] = size(facial_image);
    [~, ~, ~, ~, uniform_image] = PreprocessPartition(facial_image, width, height, 3);
    subplot(2, 5, i);
    imshow(uniform_image);
end


%% test partition
% process the function
facial_image = imread('.\test_fun_pic\YM.HA1.52.tiff');
[height, width] = size(facial_image);
ratio = 4;
[local_blocks, lbw, lbh, block_num, uniform_image] = PreprocessPartition(facial_image, width, height, ratio);

% show the original image
figure('Name','Original Image','NumberTitle','off');
imshow(facial_image);

% show the cropped image
figure('Name','Cropped Image','NumberTitle','off');
imshow(uniform_image);

% show local blocks
figure('Name','Local Blocks','NumberTitle','off');
for i = 1 : block_num
    subplot(2 * ratio - 1, 2 * ratio - 1, i);
    imshow(local_blocks(:, :, i));
end