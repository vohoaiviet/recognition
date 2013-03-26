%% 2DPCA reconstructed images

% get projected axes
[~, matrix_2dpca, ~, eigenval] = train_stage_2dpca('.\ORLTrain', 'label_orl.txt');
% test image
origin_image = double(imread('pca_rec.bmp'));
% principal component
Y = origin_image * matrix_2dpca;

% reconstructed image
rec_image = zeros(112, 92);

% Fig2.some reconstructed subimages
figure('Name','2DPCA Reconstructed Subimages','NumberTitle','off');
subimage = uint8([1 2 4 7 10]);
for i = 1 : 5
    rec_image = Y(:, subimage(i)) * matrix_2dpca(:, subimage(i))';
    subplot(1, 5, i);
    % reverse color for the sake of clarity
    imshow(imcomplement(mat2gray(rec_image, [0, 255])));
end

% Fig3. the plot of the magnitude of the eigenvalues in descreasing order. 
figure('Name','Magnitude of the eigenvalues','NumberTitle','off');
y = eigenval;
x = 1 : length(eigenval);
plot(x, y);
xlabel('No. of eigenvalues');
ylabel('Magnitude of eigenvalues');

% Fig4. some reconstructed images
figure('Name','2DPCA Reconstructed images','NumberTitle','off');
for i = 1 : 2 : 10
    for j = i : i + 1
        rec_image = rec_image + Y(:, j) * matrix_2dpca(:, j)';
    end
    imwrite(mat2gray(rec_image,  [0, 255]), ['.\FaceRec\2dpca_', num2str(i + 1), '.bmp']);
    subplot(1, 5, j / 2);
    imshow(mat2gray(rec_image, [0, 255]));
end
