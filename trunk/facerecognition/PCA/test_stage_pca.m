function [accuracy] = test_stage_pca(test_face_path, projected_face, matrix_pca, col_mean, comp_num)
%% TEST_STAGE_PCA is the training stage of face recognition system using PCA
%test_face_path      ---is the testing face folder
%projected_face      ---is the result of train face in train stage
%matrix_pca      --is the pca project matrix in train stage


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
[n, ~] = size(projected_face);
d = comp_num;
for i = 1 : file_num
    if (~test_face_name(i).isdir)
        test_face_num = test_face_num + 1;
        %read test image
        file_name = test_face_name(i).name;
        fprintf('Loading test image: %s...\n', file_name);
        test_face = imread([test_face_path, '\', file_name]);
        
        %project test image
        test_face = double(test_face(:)) - col_mean';
        test_face_projected = test_face' * matrix_pca;
        
        %nearest neighbor classifier
        dis = zeros(n, 1);
        for ii = 1 : n
            for jj = 1 : d
                 dis(ii) = dis(ii) + (projected_face(ii, jj) - test_face_projected(jj)) ^ 2;
            end
        end
        [min_dis(test_face_num), min_idx(test_face_num)] = min(dis);
       
    end
end

%% calculate the accuracy and write the result
% get train face name and indentity
fid = fopen('result_orl_pca.txt', 'wt');
for i = 1 : test_face_num
    fprintf(fid, 'distance is %d, indice is %d\n', min_dis(i), min_idx(i));
    if (abs(min_idx(i) - i) / 5 < 1)
        accuracy = accuracy + 1;
    end
end
fclose(fid);
accuracy = accuracy / test_face_num;