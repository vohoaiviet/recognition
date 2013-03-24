function featureMatrix = FeatureExtract(img, w, h, gaborFliters, ratio)
%FR is the main function.
%FNAME is the input image file name. TAG to test whether is success. RES is
%the result.


%% Partition
%ratio = 4; % can be 3, 4, 5.
blockNum = (2 * ratio - 1) ^ 2;
[localBlocks, width, height] = partition(img, ratio, w, h);


%% Gabor Filter
gaborOutput = zeros(width, height, 8, 3, blockNum);

for k = 1 : blockNum
    for i = 1 : 3
        for j = 1 : 8
            filter = double(gaborFliters{i, j});
            img = double(localBlocks(:, :, k));
            output = im2uint8(mat2gray(conv2(img, filter, 'same')));
            
            gaborOutput(:, :, j, i, k) = output;
        end
    end
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