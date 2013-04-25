function [rfld_projected, pca_matrix1, rfld_matrix, class_label] = train_stage(train_set_path, class_num, rfld_num)
%% TRAIN_STAGE is the training stage of facial recognition system
%train_set_path      ---the path of the train set directory
%ratio      ---used in partition
%pca_matrix1      ---PCA projected matrix befor FLD
%fld_matrix      ---FLD projected matrix
%pca_matrix2      ---PCA projected matrix after KNN
%rfld_matrix      ---RFLD projected matrix
%facial_feature      ---global feature after RFLD
%class_label      ---the label for FLD
%class_num      ---the number of class


%% get all train images
train_file_name = dir([train_set_path, '\*.tiff']);
train_file_num = length(train_file_name);
if (train_file_num == 0)
    disp('No train file, please check the path!');
    return;
end

% local feature
lbw = floor(127 / 6);
lbh = floor(144 / 7);
local_gabor_features = zeros(lbw * lbh * 8, 3 * 42, train_file_num);

% gabor filter mask
gabor_mask = GenGaborFilter;

%% local Gabor features
for train_file_idx = 1 : train_file_num
    train_file = imread([train_set_path, '\', train_file_name(train_file_idx).name]);
    fprintf('Loading train image: %s... \n', train_file_name(train_file_idx).name);
    [height, width] = size(train_file);
    
    % preprocess and partition
    [local_blocks, lbw, lbh, block_num] = PreprocessPartition(train_file, width, height);
    
    % Gabor filter
    gabor_filter_result = zeros(lbh, lbw, 24, block_num);
    for local_block_idx = 1 : block_num
        gabor_filter_result(:, :, :, local_block_idx) = GaborFilter(local_blocks(:, :, local_block_idx), gabor_mask);
    end
    
    block_idx = 1;
    for local_block_idx = 1 : block_num
        gabor_res_scale1 = gabor_filter_result(:, :, 1 : 8, local_block_idx);
        local_gabor_features(:, block_idx, train_file_idx) = reshape(gabor_res_scale1, lbw * lbh * 8, 1);
        block_idx = block_idx + 1;
        gabor_res_scale2 = gabor_filter_result(:, :, 9 : 16, local_block_idx);
        local_gabor_features(:, block_idx, train_file_idx) = reshape(gabor_res_scale2, lbw * lbh * 8, 1);
        block_idx = block_idx + 1;
        gabor_res_scale3 = gabor_filter_result(:, :, 17 : 24, local_block_idx);
        local_gabor_features(:, block_idx, train_file_idx) = reshape(gabor_res_scale3, lbw * lbh * 8, 1);
        block_idx = block_idx + 1;
    end
end


%% classifier synthesis
% generate label file
class_label = zeros(train_file_num, 1, 'uint8');
%class_num = 7;
for train_file_idx = 1 : train_file_num
    switch(train_file_name(train_file_idx).name(4 : 5))
        case 'AN' 
            label = 1;
        case 'DI' 
            label = 2;
        case 'FE' 
            label = 3;
        case 'HA' 
            label = 4;
        case 'SA' 
            label = 5;
        case 'SU' 
            label = 6;
        case 'NE' 
            label = 7;
        otherwise
            disp('Unknow expression!');
            return;
    end
    class_label(train_file_idx) = label;
end

%% use PCA to reduce the dimension of the local features and select (n-C)
% principal components to represnet the input data.
disp('PCA1 processing...');
local_features = zeros(train_file_num, lbw * lbh * 8);
pca_matrix1 = zeros(lbw * lbh * 8, train_file_num - class_num, block_num * 3);
pca1_projected_local_features = zeros(train_file_num, train_file_num - class_num, block_num * 3);
for local_block_idx = 1 : block_num * 3
    for train_file_idx = 1 : train_file_num
        local_features(train_file_idx, :) = local_gabor_features(:, local_block_idx, train_file_idx)';
    end
    [eig_vec, ~] = princomp(local_features, 'econ');
    pca_matrix1_i = eig_vec(:, 1 : train_file_num - class_num);
    for eig_vec_idx = 1 : train_file_num - class_num
        pca_matrix1_i(:, eig_vec_idx) = pca_matrix1_i(:, eig_vec_idx) / norm(pca_matrix1_i(:, eig_vec_idx));
    end
    pca_matrix1(:, :, local_block_idx) = pca_matrix1_i;
    pca1_projected_local_features(:, :, local_block_idx) = local_features * pca_matrix1_i;
end


%% use RFisher linear discriminant(RFLD) analysis to seek a projection for
% each local feature such that it can be optimally separated from the
% others.
disp('RFLD processing...');
rfld_matrix = zeros(train_file_num - class_num, rfld_num, block_num * 3);
rfld_projected = zeros(train_file_num, rfld_num, block_num * 3);
for local_block_idx = 1 : block_num * 3
    rfld_input_sample_i = pca1_projected_local_features(:, :, local_block_idx)';
    [rfld_matrix_i, rfld_projected_i] = RFLD(rfld_input_sample_i, class_label, class_num, rfld_num);
    % normalized to have zero mean and unit standard deviation
    rfld_projected_i = mapstd(rfld_projected_i, 0, 1);
    
    rfld_matrix(:, :, local_block_idx) = rfld_matrix_i;
    rfld_projected(:, :, local_block_idx) = rfld_projected_i;
end