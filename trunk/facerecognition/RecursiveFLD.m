function [W, projected_data] = RecursiveFLD(sample, class_label, class_num, comp_num)
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

[~, eigen_value] = eig(Sw);
eigen_value = diag(eigen_value);
Sw = Sw + sum(eigen_value) / sum(eigen_value ~= 0);

%% Get w1, The same as FLD
[eigenvec, eigenval] = eig(Sw \ Sb);
eigenval = diag(eigenval);
[~, indice] = sort(eigenval, 'descend');
eigenvec = eigenvec(:, indice);

W(:, 1) = eigenvec(:, 1) / norm(eigenvec(:, 1));


%% Recursive process
% wk is the latest obtained feature vector
wk = W(:, 1);
% dim is the dimension of Bk and Wk, feature_num is the number of feature
% obtained.
dim = d; feature_num = 1;

while true
    % Wnk = [vk, v(k + 1), ..., vd], is a set of orthonormal basis for the
    % null space of the space spanned by w1, ..., w(k - 1), such that the
    % set of vector{w1, ..., w(k - 1), vk, v(k + 1), ..., vd} constitutes
    % an orthonormal basis for R(d)
    Wnk = null(W');
    
    % Swk is the within-class scatter matrix at kth step, see formula (32).
    Swk = (Wnk * Wnk') * Sw * (Wnk * Wnk');
    % Sbk is the between-class scatter matrix at the kth step, see
    % formula(33).
    Sbk = (Wnk * Wnk') * Sb * (Wnk * Wnk');
    
    % The end of the recursive process Bk is a zero matrix. ie Sbk is a
    % zero matrix.
    if (~any(Sbk(:)))
        break;
    end
    
    % Wk and Bk is the (d + k - 1) * d matrix. see formula(22)
    Wk(1 : d, :) = Swk;
    Wk(dim + 1, :) = wk';
    
    Bk(1 : d, :) = Sbk;
    Bk(dim + 1, :) = zeros(1, d);
    
    % Dimension of Wk, Bk and W is added. 
    dim = dim + 1;
    feature_num = feature_num + 1;
    
    % Get another feature vector. See formula(34). 
    [vec, val] = eig((Wk' * Wk) \ (Wk' * Bk));
    [~, max_pos] = max(diag(val));
    wk = vec(:, max_pos);
    W(:, feature_num) = vec(:, max_pos) / norm(vec(:, max_pos));
    if (feature_num == comp_num)
        projected_data = W' * sample;
        return;
    end
end