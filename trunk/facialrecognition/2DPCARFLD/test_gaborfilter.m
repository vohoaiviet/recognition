clear all;
close all;

test_image = imread('.\test_fun_pic\Crop1.bmp');
% get Gabor filter mask
gabor_mask = GenGaborFilter;
filter_output = GaborFilter(test_image, gabor_mask);

% show Gabor output images
figure('Name','Gabor output','NumberTitle','off');
for i = 1 : 24
    subplot(3, 8, i);
    imshow(filter_output(:, :, i));
end