%% test GaborFilter
clear all;
close all;

test_img = imread('A (2).bmp');
[height, width] = size(test_img);

filter_output = GaborFilter(test_img, height, width);
for i = 1 : 24
    figure, imshow(filter_output(:, :, i));
end