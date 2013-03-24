clear all;
close all;

%% ##############Get test image##############
%testImage = imread('YM.HA2.53.tiff');
fname = 'Image001.jpg';
imageSize = [280, 180];
 testImage = imresize(detect_face(imresize(imread(fname),[375,300])),imageSize);
 testImage = testImage(1:200, :);
dTestImage = double(testImage);


%% ##############Gabor filter################
gaborFilters = GenGaborFilter;
for i = 1 : 3
    for j = 1 : 8
        filter = double(gaborFilters{i, j});
        result = mat2gray(conv2(dTestImage, filter, 'same'));
        resImage = im2uint8(result);
        figure, imshow(resImage);
    end
end