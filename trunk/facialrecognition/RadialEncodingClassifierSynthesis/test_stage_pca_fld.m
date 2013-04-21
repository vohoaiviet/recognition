function [accuracy] = test_stage_pca_fld(test_set_path, fld_projected, pca_matrix1, fld_matrix, class_label, ratio)
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
test_file_name = dir([test_set_path, '\*.tiff']);
test_file_num = length(test_file_name);
train_file_num = length(class_label);
class_num = 7;

% for each test image get its minimum distance and minimum indice of train
% test
min_dis = zeros(test_file_num, 1, 'double');
min_idx = zeros(test_file_num, 1, 'uint8');

% gabor filter mask
gabor_mask = GenGaborFilter;

temp = 0;
for test_file_idx = 1 : test_file_num
    test_file = imread([test_set_path, '\', test_file_name(test_file_idx).name]);
    fprintf('Loading test image: %s... \n', test_file_name(test_file_idx).name);
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
                radial_encode_res = RadialEncode(gabor_filter_result(:, :, (gb_scale - 1) * 8 + gb_orientation, local_block_idx), lbw, lbh);
                gb_orientation_res(:, gb_orientation) = radial_encode_res(:);
            end
            radial_encode_result(:, radial_encode_idx) = gb_orientation_res(:);
            radial_encode_idx = radial_encode_idx + 1;
        end
    end
    local_feature_array = radial_encode_result;
    
    % apply PCA to the result of radial encoding
    local_features = local_feature_array';
    pca1_projected_local_features = zeros(3 * block_num, train_file_num - class_num);
    for local_block_idx = 1 : block_num * 3
        pca1_projected_local_features(local_block_idx, :) = local_features(local_block_idx, :) * pca_matrix1(:, :, local_block_idx);
    end
    
    % apply FLD to project feature matrices on to a discriminating,
    % low-dimensional subspace.
    fld_projected_local_features = zeros(3 * block_num, class_num - 1);
    for local_block_idx = 1 : block_num * 3
        fld_projected_local_features(local_block_idx, :) = pca1_projected_local_features(local_block_idx, :) * fld_matrix(:, :, local_block_idx);
        fld_projected_local_features(local_block_idx, :) = mapstd(fld_projected_local_features(local_block_idx, :));
    end

    % local classifier k-nearest neighbor(KNN) with k = 1. Th ouput of KNN
    % is C-Dimensional vector as estimated probabilities of the C classes.
    % see formula (4)
    train_vec_num = size(fld_projected, 1);
    
    nearest_block = zeros(train_vec_num, 1, 'uint8');
    nearest_fr = zeros(class_num, 1);
    for local_block_idx = 1 : block_num * 3
        temp_projected = fld_projected(:, :, local_block_idx);
%         dis = realmax;
        dist_all = zeros(train_vec_num, 1);
        for train_vec_idx = 1 : train_vec_num
            distance = norm(fld_projected_local_features(local_block_idx, :) - temp_projected(train_vec_idx, :));
            dist_all(train_vec_idx) = distance;
%             if (dis > distance)
%                 dis = distance;
%                 %temp = train_vec_idx;
%                 % fprintf('block_idx: %d, train_vec_idx: %d, distance: %f\n', local_block_idx, train_vec_idx, distance); 
%             end
        end
        [~, index] = sort(dist_all);
        nearest_block(index(1)) = nearest_block(index(1)) + 3;
        nearest_block(index(2)) = nearest_block(index(2)) + 2;
        nearest_block(index(3)) = nearest_block(index(3)) + 1;
        
%         nearest_fr(class_label(index(1))) = nearest_fr(class_label(index(1))) + 3;
%         nearest_fr(class_label(index(2))) = nearest_fr(class_label(index(2))) + 2;
%         nearest_fr(class_label(index(3))) = nearest_fr(class_label(index(3))) + 1;
        %nearest_block(temp) = nearest_block(temp) + 1;
    end
    
    [min_dis(test_file_idx), min_idx(test_file_idx)] = max(nearest_block);
%     [min_dis(test_file_idx), min_idx(test_file_idx)] = max(nearest_fr);
end

% a map from facial expression to label;
label_map = cell(7, 1);
label_map{1} = 'AN';
label_map{2} = 'DI';
label_map{3} = 'FE';
label_map{4} = 'HA';
label_map{5} = 'SA';
label_map{6} = 'SU';
label_map{7} = 'NE';

% calculate the accuracy
accuracy = 0;
for test_file_idx = 1 : test_file_num
    real_expression = test_file_name(test_file_idx).name(4 : 5);
    test_expression = label_map{(class_label(min_idx(test_file_idx)))};
    % test_expression = label_map{min_idx(test_file_idx)};
    fprintf('real expression: %s, test expression: %s, minnimum distance %f\n', real_expression, test_expression, min_dis(test_file_idx));
    if (strcmp(real_expression, test_expression))
        accuracy = accuracy + 1;
    end
end
accuracy = accuracy / test_file_num;
