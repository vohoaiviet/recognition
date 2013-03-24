clear all;
close all;

fname = 'Image001.jpg';

imageSize = [280, 180];
img = imread(fname);
imshow(img);

img = imresize(detect_face(imresize(img,[375,300])),imageSize);
figure, imshow(img);
figure, imshow(img(1:200, :));