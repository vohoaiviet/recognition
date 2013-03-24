%% test GridEncode
clear all;
close all;

test_img = imread('A (2).bmp');
[height, width] = size(test_img);

encode_image = mat2gray(GridEncode(test_img, height, width, 4));
imshow(encode_image);