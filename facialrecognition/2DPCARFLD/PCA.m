function [mapped_data, eigenvec] = PCA(data, comp)
%% PCA used for principal components analysis
%data      ---the data for principal components analysis
%comp      ---number of components selected
%mapped_data      ---projected data
%eigenvec      ---selected maximum eigen vector


%% n X d, n samples and each sample have d dimensions
[n, ~] = size(data);

% subtract off the mean for each columns
col_mean = mean(data);
data = data - repmat(col_mean, n, 1);

% calculate the covariance matrix
cov_matrix = data' * data / (n - 1);

% get eigenvectors and eigenvalues
[eigenvec, eigenval] = eig(cov_matrix);

% select principal components
eigenval = diag(eigenval);
[~, indice] = sort(eigenval, 'descend');
eigenvec = eigenvec(:, indice);

% return paramaters
eigenvec = eigenvec(:, 1 : comp);
mapped_data = data * eigenvec;