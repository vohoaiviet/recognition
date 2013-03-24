clear all;
close all;

fname = 'KA.HA1.29.tiff';
info = imfinfo(fname);

fimg = imread(fname);
imshow(fimg);

gimg = preprocessing(fimg, info);
figure, imshow(gimg);