function [mapped_data, eigenvec] = PCA(data, comp)
%% PCA used for principal components analysis
% %COMP      ===      number of components selected
% 
% % %% program
% [n, ~] = size(data);
% 
% % subtract off the mean for each columns
% col_mean = mean(data);
% data = data - repmat(col_mean, n, 1);
% 
% % calculate the covariance matrix
% cov_matrix = data' * data / (n - 1);
% 
% % get eigenvectors and eigenvalues
% [eigenvec, eigenval] = eig(cov_matrix);
% 
% % select principal components
% eigenval = diag(eigenval);
% [~, indice] = sort(eigenval, 'descend');
% eigenvec = eigenvec(:, indice);
% 
% % return paramaters
% eigenvec = eigenvec(:, 1 : comp);
% mapped_data = data * eigenvec;



% program
% get eigenvectors and eigenvalues
[n, ~] = size(data);
[eigenvec, mapped_data, eigenval]  = princomp(data, 'econ');
[~, indice] = sort(eigenval, 'descend');
eigenvec = eigenvec(:, indice);
eigenvec = eigenvec(:, 1 : comp);
col_mean = mean(data);
data = data - repmat(col_mean, n, 1);
%mapped_data = mapped_data(:, 1 : comp);
mapped_data = data * eigenvec;