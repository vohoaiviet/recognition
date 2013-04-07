function [accuracy] = test_stage(test_set_path, facial_feature, fld_projected, pca_matrix1, fld_matrix, pca_matrix2, rfld_matrix, class_label, ratio)
%% TEST STAGE is the training stage of facial recognition system
%test_set_path      ---the path of the test set directory
%ratio      ---used in partition
%class_label      ---the label of each feature after FLD
%pca_matrix1      ---PCA projected matrix befor FLD
%fld_matrix      ---FLD projected matrix
%pca_matrix2      ---PCA projected matrix after KNN
%rfld_matrix      ---RFLD projected matrix
%facial_feature      ---global feature after RFLD
%fld_projected      ---local feature after FLD
%accuracy       ---the accuracy of this system


%% get all test images
test_file_name = dir([test_set_path, '\.*tiff']);
test_file_num = length(test_file_name);
class_num = 7;

% for each test image get its minimum distance and minimum indice of train
% test
min_dis = zeros(test_file_num, 1, 'double');
min_idx = zeros(test_file_num, 1, 'uint8');

% gabor filter mask
gabor_mask = GenGaborFilter;

for test_file_idx = 1 : test_file_num
    test_file = imread(test_file_name{test_file_idx}.name);
    [height, width] = size(test_file);
    
    % preprocess and partition
    [local_blocks, lbw, lbh, block_num] = PreprocessPartition(test_file, width, height, ratio);
    
    % Gabor filter
    gabor_filter_result = zeros(lbh, lbw, 24, block_num);
    for local_block_idx = 1 : block_num
        gabor_filter_result(:, :, :, local_block_idx) = GaborFilter(local_blocks(:, :, local_block_idx), gabor_mask);
    end
    
    % radial encode
    radial_encode_result = zeros(90 * 8, 3 * block_num);
    radial_encode_idx = 1;
    for local_block_idx = 1 : block_num
        for gb_scale = 1 : 3
            gb_orientation_res = zeros(90, 8);
            for gb_orientation = 1 : 8
                radial_encode_res = RadialEncode(gabor_filter_result(:, :, (gb_scale - 1) * 8 + gb_orientation, local_block_idx));
                gb_orientation_res(:, gb_orientation) = radial_encode_res(:);
            end
            radial_encode_result(:, radial_encode_idx) = gb_orientation_res(:);
            radial_encode_idx = radial_encode_idx + 1;
        end
    end
    local_feature_array = radial_encode_result;
    
    % apply PCA to the result of radial encoding
    local_features = local_feature_array';
    pca1_projected_local_features = local_features * pca_matrix1;
    
    % apply FLD to project feature matrices on to a discriminating,
    % low-dimensional subspace.
    fld_projected_local_features = pca1_projected_local_features * fld_matrix;
    % normalized to have zero mean and unit standard deviation
    fld_projected_local_features = mapstd(fld_projected_local_features, 0, 1);
    
    % local classifier k-nearest neighbor(KNN) with k = 1. Th ouput of KNN
    % is C-Dimensional vector as estimated probabilities of the C classes.
    % see formula (4)
    local_classifiers_output = zeros(class_num, block_num * 3);
    [train_vec_num, ~] = size(fld_projected);
    for local_block_idx = 1 : block_num * 3
        dis = zeros(class_num, 1);
        probabilities = zeros(class_num, 1);
        dis(1 : class_num) = realmax;
        for train_vec_idx = 1 : train_vec_num
            dis(class_label(train_vec_idx)) = min(dis(class_label(train_vec_idx)), norm(fld_projected_local_features(local_block_idx, :) - fld_projected(train_vec_idx, :)));
        end
        
        denominator = 0;
        for i = 1 : class_num
            denominator = denominator + 1 / (dis(i) + 1);
        end
        
        for pro_idx = 1 : class_num
            probabilities(pro_idx) = 1 / (dis(i) + 1) / denominator;
        end
        local_classifiers_output(:, local_block_idx) = probabilities;
    end
    
    % concatenating the outputs of all local classifiers to generate its
    % intermediate feature matrix
    intermediate_feature = local_classifiers_output(:);
    
    % apply PCA to project the intermediate feature matrice on to
    % low_dimensional subspace.
    pca2_projected_global_features = intermediate_feature * pca_matrix2;
    
    % apply RFLD to project the intermediate feature matrices onto a
    % discriminating , low-dimensional subspace.
    rfld_projected_global_features = pca2_projected_global_features * rfld_matrix;
    
    % normalized the global features after RFLD to  have zero mean and unit
    % standard
    global_features = mapstd(rfld_projected_global_features, 0, 1);
    
    
    % a nearest-neighbor classifier to make final decision-making stage.
    for global_feature_idx = 1 : train_vec_num
        dis(global_feature_idx) = normal(global_features - facial_feature(global_feature_idx, :));
    end
    [min_dis(test_file_idx), min_idx(test_file_idx)] = min(dis);
end

% a map from facial expression to label;
label_map = cell(1, 1);
label_map{1, 1}(1) = 'AN';
label_map{1, 1}(2) = 'DI';
label_map{1, 1}(3) = 'FE';
label_map{1, 1}(4) = 'HA';
label_map{1, 1}(5) = 'SA';
label_map{1, 1}(6) = 'SU';
label_map{1, 1}(7) = 'NE';

% calculate the accuracy
accuracy = 0;
for test_file_idx = 1 : test_file_num
    real_expression = test_file_name{test_file_idx}.name(4 : 5);
    test_expression = label_map{1, 1}(class_label(min_idx(test_file_idx)));
    if (strcmp(real_expression, test_expression))
        accuracy = accuracy + 1;
    end
end
accuracy = accuracy / test_file_num;
