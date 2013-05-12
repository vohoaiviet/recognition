function [mapped_data, eigenvec, row_mean] = PCA(data, comp)
%% PCA used for principal components analysis
%data      ---the data for principal components analysis
%comp      ---number of components selected
%mapped_data      ---projected data
%eigenvec      ---selected maximum eigen vector


%% d X n, n samples and each sample have d dimensions
[~, n] = size(data);

% subtract off the mean for each columns
row_mean = mean(data, 2);
data = data - repmat(row_mean, 1, n);

% calculate the covariance matrix
surr_cov_matrix = data' * data / (n - 1);

% get eigenvectors and eigenvalues
[eigenvec, eigenval] = eig(surr_cov_matrix);

% select principal components
eigenval = diag(eigenval);
[~, indice] = sort(eigenval, 'descend');
eigenvec = eigenvec(:, indice);

% return paramaters
eigenvec = eigenvec(:, 1 : comp);
eigenvec = data * eigenvec;

for i = 1 : comp
    eigenvec(:, i) = eigenvec(:, i) / norm(eigenvec(:, i)) * -1;
end

mapped_data = eigenvec' * data;