clear all;
close all;
pack;

%% Read image and initialization
fname = 'Image001.jpg';
imageSize = [280, 180];
 img = imresize(detect_face(imresize(imread(fname),[375,300])),imageSize);
 img = img(1:200, :);
 
imgSize = size(img);
w = imgSize(1);
h = imgSize(2);

ratio = 3;
gaborFilters = GenGaborFilter;


%% Partition
blockNum = (2 * ratio - 1) ^ 2;
[localBlocks, width, height] = partition(img, ratio, w, h);

for i = 1 : 1
    disp('show local blocks');
    figure, imshow(localBlocks(:, :, i));
end


%% Gabor Filter
gaborOutput = zeros(width, height, 8, 3, blockNum);

for k = 1 : blockNum
    for i = 1 : 3
        for j = 1 : 8
            filter = double(gaborFilters{i, j});
            img = double(localBlocks(:, :, k));
            output = im2uint8(mat2gray(conv2(img, filter, 'same')));
            
            gaborOutput(:, :, j, i, k) = output;
        end
    end
end

for i = 1 : 1
    disp('show gabor output');
    figure, imshow(uint8(gaborOutput(:, :, 1, 1, i)));
end


%% Radial encoding
featureNum = 1;
localFeatures = zeros(90, 8, blockNum * 3);
featureMatrix = zeros(720, blockNum * 3);
for i = 1 : blockNum
    for j = 1 : 3
        for k = 1 : 8
            encodeRes = radialencode(gaborOutput(:, :, k, j, i), width, height);
            localFeatures(:, k, featureNum) = encodeRes(:);
        end
        featureNum = featureNum + 1;
    end
end

for i = 1 : (blockNum * 3)
    featureMatrix(:, i)  = reshape(localFeatures(:, :, i), 720, 1);
end