clear all;
close all;

facial_image = imread('.\test_fun_pic\YM.HA1.52.tiff');
[height, width] = size(facial_image);
ratio = 4;

% preprocess and partition
[local_blocks, lbw, lbh, block_num, ~] = PreprocessPartition(facial_image, width, height, ratio);

figure('Name','Local Region','NumberTitle','off');
for i = 1 : block_num
    subplot(2 * ratio - 1, 2 * ratio - 1, i);
    imshow(uint8(local_blocks(:, :, i)));
end

% radial encode
figure('Name', 'Radial Result', 'NumberTitle', 'off');
for i = 1 : block_num
    subplot(2 * ratio - 1, 2 * ratio - 1, i);
    [encode_result, pixel_num] = RadialEncode(local_blocks(:, :, i), lbw, lbh);
    imshow(uint8(encode_result));
end