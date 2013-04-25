function [W, projected_sample] = RFLD(sample, class_label, class_num, extracted_feature_num)
%% RFLD is Recursive Fisher Linear Discriminant. It can extracts more feature vectors than Fisher Linear Discriminant.
%sample      ---a set of n d-dimensional samples x1, x2, ..., xn
%class_label      ---the array contain each sample's class name
%class_num      ---total number of classes
%extracted_feature_num      ---the number of extracted features
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


%% calculate between-class scatter matrix Sb. See formula (2).
for i = 1 : class_num
    Sb = each_class_num(i) * (Mi(:, i) - M) * (Mi(:, i) - M)' + Sb;
end


%% claculate within-class scatter matrix Sw. See formula (5).
for i = 1 : n
    Si(:, :, class_label(i)) = (sample(:, i) - Mi(:, class_label(i))) * (sample(:, i) - Mi(:, class_label(i)))' + Si(:, :, class_label(i));
end

for i = 1 : class_num
    Sw = Si(:, :, i) + Sw;
end


%% seek the direction first feature direction.
[w1, eigenval] = eig(Sw \ Sb);

eigenval = diag(eigenval);
[~, indice] = sort(eigenval, 'descend');
w1 = w1(:, indice);
w1 = w1(:, 1) / norm(w1(:, 1));

% W(:, 1) initializes to w1
W = zeros(d, extracted_feature_num);
W(:, 1) = w1;

% overcome over-fitting
[~, eig_val] = eig(Sw);
ave_eigv = mean(nonzeros(diag(eig_val)));
Sw = Sw + ave_eigv;


%% recursive process
% wk is the  feature vector obtained in the previous process, initialized
% as w1 obtain by FLD.
wk = w1;

% dim is the dimension of Bk and Wk, feature_num is the number of feature
% obtained.
dim = d; feature_num = 1;

while true
    % Wnk = [vk, v(k + 1), ..., vd], is a set of orthonormal basis for the
    % null space of the space spanned by w1, ..., w(k - 1). See formula
    % (26)
    Wnk = null(W');
    
    Wnk_product = (Wnk * Wnk');
    % Swk is the within-class scatter matrix at kth step, see formula (32).
    % Swk = (Wnk * Wnk') * Sw * (Wnk * Wnk');
    Swk = Wnk_product * Sw * Wnk_product;
    % Sbk is the between-class scatter matrix at the kth step, see
    % formula(33).
    Sbk = Wnk_product * Sb * Wnk_product;
    
    % the end of the recursive process Bk is a zero matrix or extracts enough feature vector.
    if (~any(Sbk(:)) || feature_num >= extracted_feature_num)
        break;
    end
    
    % Wk and Bk is the (d + k - 1) * d matrix. see formula (22)
    Wk(1 : d, :) = Swk;
    Wk(dim + 1, :) = wk';
    
    Bk(1 : d, :) = Sbk;
    Bk(dim + 1, :) = zeros(1, d);
    
    % dimension of Wk, Bk and W is added. 
    dim = dim + 1;
    feature_num = feature_num + 1;
    
    % get another feature vector. See formula(34). 
    [vec, val] = eig((Wk' * Wk) \ (Wk' * Bk));
    [~, max_pos] = max(diag(val));
    wk = vec(:, max_pos);
    W(:, feature_num) = vec(:, max_pos) / norm(vec(:, max_pos));
end

projected_sample = sample' * W;