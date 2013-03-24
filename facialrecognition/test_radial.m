clear all;
close all;

img = imread('YM.HA2.53.tiff');
imgSize = size(img);
[result, SUM, NUM] = radialencode(img, imgSize(1), imgSize(2));

%showRes = mat2gray(result);
imshow(uint8(result));