function [projected_image, projected_axes, eigenval] = TDPCA(train_image, projection_axis_num)
%% TDPCA Used for 2-D principal components analysis
%train_image      ===total training image
%projected_axis      ===number of projection axes selected

%% calculate the image covariance(scatter) matrix Gt
[m, n, M] = size(train_image);
projected_image = zeros(m, projection_axis_num, M);
% average_image is the average iamge of all training samples.
average_image = zeros(m, n);
for i = 1 : M
    average_image = average_image + train_image(:, :, i);
end
average_image = average_image / M;

% Gt is the image covariance(scatter) matrix
Gt = zeros(n, n);
for i = 1 : M
    Gt = Gt + (train_image(:, :, i) - average_image)' * (train_image(:, :, i) - average_image);
end
Gt = Gt / M;

%% get projected matrix and do projection
[eigenvec, eigenval] = eig(Gt);
eigenval = diag(eigenval);
% eigenvectors of Gt corresponding to the first d largest eigenvalue
[eigenval, indice] = sort(eigenval, 'descend');
eigenvec = eigenvec(:, indice);
%projected_axes = orth(eigenvec(:, 1 : projection_axis_num));
projected_axes = eigenvec(:, 1 : projection_axis_num);
for i = 1 : projection_axis_num
    projected_axes(:, i) = eigenvec(:, i) / norm(eigenvec(:, i));
end

% get the projected image
for i = 1 : M
    projected_image(:, :, i) = train_image(:, :, i) * projected_axes;
end