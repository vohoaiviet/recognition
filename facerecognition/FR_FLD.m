function [W, sample_projected, Sw, Sb, M1, M2] = FR_FLD(sample, class_label, class_num)
%% 
%CLASS   ===   class label
%CLASSNUM   ===   number of class


%% program start
[d, n] = size(sample);
% M is the sample mean for the whole set
M = mean(sample, 2);
% Mi is the sample mean for class i
Mi = zeros(d, class_num);
% S is the within-scatter matrix
Sw = zeros(d, d);
% Si is the within-class scatter matrix for class i
Si = zeros(d, d, class_num);
% Sb is the between-class scatter matrix
Sb = zeros(d, d);
%eachClassNum is the number of samples in each class
each_class_num = zeros(class_num, 1);


%% calculate sample mean for each class
for i = 1 : n
    Mi(:, class_label(i)) = Mi(:, class_label(i)) + sample(:, i);
    each_class_num(class_label(i)) = each_class_num(class_label(i)) + 1;
end

for i = 1 : class_num
    Mi(:, i) = Mi(:, i) / each_class_num(i);
end


%% calculate between-class scatter matrix Sb
for i = 1 : class_num
    Sb = each_class_num(i) * (Mi(:, i) - M) * (Mi(:, i) - M)' + Sb;
end


%% claculate within-class scatter matrix Sw
for i = 1 : n
    Si(:, :, class_label(i)) = (sample(:, i) - Mi(:, class_label(i))) * (sample(:, i) - Mi(:, class_label(i)))' + Si(:, :, class_label(i));
end

for i = 1 : class_num
    Sw = Si(:, :, i) + Sw;
end

% over come the problem of over-fitting, addition the average eigenvalue of
% Sw to each element of Sw.
[~, eigen_val] = eig(Sw);
eigen_val = diag(eigen_val);
avg_eigv = sum(eigen_val) / sum(eigen_val ~= 0);
Sw = Sw + avg_eigv;


%% Get W
[W, eigenval] = eig(Sw \ Sb);
eigenval = diag(eigenval);
[~, indice] = sort(eigenval, 'descend');
W = W(:, indice);

% return paramaters
W = W(:, 1 : class_num - 1);
sample_projected = W' * sample;


%% Use for test
M1 = Mi(:, 1);
M2 = Mi(:, 2);