function [W, eigenval, Sw, Sb, M1, M2, W_t, WW] = FLD(sample, class_label, class_num)
%% FLD is  Fisher Linear Discriminant. The objective of FLD is to seek the direction w not only maximizing the between-class scatter of the projected samples, but also minimizing the within-class scatter.
%sample      ---a set of n d-dimensional samples x1, x2, ..., xn
%class_label      ---the array contain each sample's class name
%class_num      ---total number of classes
%W      ---the matrix each column is a projected direction w


%% samples are arranged by d X n matrice
[d, n] = size(sample);

% M is the d-dimensional sample mean for the whole set
M = mean(sample, 2);
% Mi is the sample mean for class i
Mi = zeros(d, class_num);
% Sw is the within-class scatter matrix
Sw = zeros(d, d);
% Si is the class scatter matrix for class i
Si = zeros(d, d, class_num);
% Sb is the between-class scatter matrix
Sb = zeros(d, d);
%each_class_num is the number of samples in each class
each_class_num = zeros(class_num, 1);


%% calculate sample mean for each class. See formula (4)
for i = 1 : n
    Mi(:, class_label(i)) = Mi(:, class_label(i)) + sample(:, i);
    each_class_num(class_label(i)) = each_class_num(class_label(i)) + 1;
end

for i = 1 : class_num
    Mi(:, i) = Mi(:, i) / each_class_num(i);
end


%% calculate between-class scatter matrix Sb. See formula (2)
for i = 1 : class_num
    Sb = each_class_num(i) * (Mi(:, i) - M) * (Mi(:, i) - M)' + Sb;
end


%% claculate within-class scatter matrix Sw. See formula (5)
for i = 1 : n
    Si(:, :, class_label(i)) = (sample(:, i) - Mi(:, class_label(i))) * (sample(:, i) - Mi(:, class_label(i)))' + Si(:, :, class_label(i));
end

for i = 1 : class_num
    Sw = Si(:, :, i) + Sw;
end


%% seek the direction w. See formula (8)
[W, eigenval] = eig(Sw \ Sb);

eigenval = diag(eigenval);
[~, indice] = sort(eigenval, 'descend');
W = W(:, indice);
WW = W;

% return paramaters
W = W(:, 1 : class_num - 1);


%% code below is used for test
M1 = Mi(:, 1);
M2 = Mi(:, 2);

% another method to calculate  betweem-class scatter. See formula (3.48)
Sb_t = (M1 - M2) * (M1 - M2)';
[W_t, eigenval_t] = eig(Sw \ Sb_t);
eigenval_t = diag(eigenval_t);
[~, indice_t] = sort(eigenval_t, 'descend');
W_t = W_t(:, indice_t);

% return paramaters
W_t = W_t(:, 1 : class_num - 1);
