%% 2DPCA reconstructed images

% get projected axes
[~, matrix_2dpca] = train_stage_2dpca('.\ORLTrain', 'label_orl.txt');
% test image
origin_image = double(imread('pca_rec.bmp'));
% principal component
Y = origin_image * matrix_2dpca;

% reconstructed image
rec_image = zeros(112, 92);

for i = 1 : 2 : 10
    for j = i : i + 1
        rec_image = rec_image + Y(:, j) * matrix_2dpca(:, j)';
    end
    imwrite(mat2gray(rec_image), ['.\FaceRec\2dpca_', num2str(i + 1), '.bmp']);
    figure, imshow(mat2gray(rec_image));
end