function [accuracy] = test_stage_rfld(test_face_path, projected_face, pca_matrix, rfld_matrix, train_face_name, comp_num, row_mean)
%% TEST_STAGE_RFLD is the training stage of face recognition system using Recursive Fisher Linear Discriminant
%test_face_path      ---is the testing face folder
%projected_face      ---is the result of train face in train stage
%projected_face      ---the projected data after PCA and FLD
%pca_matrix      ---PCA projected matrix
%fld_matrix      ---FLD projected matrix
%train_face_name      ---train face name used to calculating accuracy
%accuracy      ---the accuracy of this face recognition system


%% Test stage initialize
disp('Test stage: load image and process');

% get all test face name
test_face_name = dir(test_face_path);
file_num = length(test_face_name);

% number of test face and the accuracy
test_face_num = 0;
accuracy = 0;
min_dis = zeros(200, 1);
min_idx = zeros(200, 1);


%% read each test face and process
[~, n] = size(projected_face);
projected_face = projected_face(1 : comp_num, :);
rfld_matrix = rfld_matrix(:, 1 : comp_num);
for i = 1 : file_num
    if (~test_face_name(i).isdir)
        test_face_num = test_face_num + 1;
        %read test image
        file_name = test_face_name(i).name;
        fprintf('Loading test image: %s...\n', file_name);
        test_face = double(imread([test_face_path, '\', file_name]));
        
        %project test image using PCA and FLD matrix
        test_face = test_face(:) - row_mean;
        pca_rfld_projected =  rfld_matrix' * (pca_matrix' * test_face);
        
        %nearest neighbor classifier
        dis = zeros(n, 1);
        for ii = 1 : n
            dis(ii) = norm(projected_face(:, ii) - pca_rfld_projected);
        end
        
        [min_dis(test_face_num), min_idx(test_face_num)] = min(dis);
    end
end


%% calculate the accuracy and write the result
% get train face name and indentity
fid = fopen('result_orl.txt', 'wt');
for i = 1 : test_face_num
    fprintf(fid, '%s, distance is %d, nearest is %s.', test_face_name(i + 2).name, min_dis(i), cell2mat(train_face_name{min_idx(i),1}));
    if (floor((min_idx(i) - 1) / 5) == floor((i - 1) / 5))
        accuracy = accuracy + 1;
        fprintf(fid, 'recognition correct!\n');
    else
        fprintf(fid, 'recognition wrong to %s\n', cell2mat(train_face_name{min_idx(i),1}));
    end
end
fclose(fid);
accuracy = accuracy / test_face_num;