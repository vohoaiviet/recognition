clear all;
close all;

facial_image = imread('.\test_fun_pic\YM.HA1.52.tiff');
[height, width] = size(facial_image);
ratio = 3;

% preprocess and partition
[local_blocks, lbw, lbh, block_num, ~] = PreprocessPartition(facial_image, width, height, ratio);

% radial encode
for i = 1 : block_num
    subplot(5, 5, i);
    [encode_result, pixel_num] = RadialEncode(local_blocks(:, :, i), lbw, lbh);
    imshow(uint8(encode_result));
end