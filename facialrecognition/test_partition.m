clear all;
close all;

fname = 'KA.HA1.29.tiff';

fimg = imread(fname);
info = imfinfo(fname);
fimg = preprocessing(fimg, info);
imgSize = size(fimg);

imshow(fimg);

ratio = 5;
regionNum = (2 * ratio - 1) ^ 2;
[localRegions, w, h] = partition(fimg, ratio, imgSize(1), imgSize(2));

% for i = 1 : regionNum
%     figure, imshow(localRegions(:, :, i));
% end

num = 2 * ratio - 1;
img = zeros((num + num - 1) * w, (num + num - 1) * h);
img = uint8(img + 255);


cnt = 1;
for i = 1 : 2  : (2 * num - 1)
    x = i * w;
    for j = 1 : 2 : (2 * num - 1)
        y = j * h;
        img(x - w + 1:x, y - h + 1:y) = localRegions(:, :, cnt);
        cnt = cnt + 1;
    end
end

figure, imshow(img);