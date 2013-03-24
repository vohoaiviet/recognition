function [accuracy] = test_stage_2dpca(test_face_path, projected_face, matrix_2dpca, train_face_name)
%% TEST_STAGE_PCA is the training stage of face recognition system using PCA
%test_face_path      ---is the testing face folder
%projected_face      ---is the result of train face in train stage
%matrix_2dpca      --is the 2d-pca project matrix in train stage


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
[m, d, M] = size(projected_face);
for i = 1 : file_num
    if (~test_face_name(i).isdir)
        test_face_num = test_face_num + 1;
        %read test image
        file_name = test_face_name(i).name;
        fprintf('Loading test image: %s...\n', file_name);
        test_face = imread([test_face_path, '\', file_name]);
        
        %project test image
        test_face = double(test_face);
        test_face_projected = test_face * matrix_2dpca;
        
        %nearest neighbor classifier
        dis = zeros(M, 1);
        for ii = 1 : M
            for kk = 1 : d
                for jj = 1 : m
                 dis(ii) = dis(ii) + (projected_face(jj, kk, ii) - test_face_projected(jj, kk)) ^ 2;
                end
            end
        end
        [min_dis(test_face_num), min_idx(test_face_num)] = min(dis);
    end
end

%% calculate the accuracy and write the result
% get train face name and indentity
fid = fopen('result_orl_2dpca.txt', 'wt');
for i = 1 : test_face_num
    fprintf(fid, 'distance is %d, indice is %d.', min_dis(i), min_idx(i));
    if (abs(min_idx(i) - i) / 5 < 1)
        accuracy = accuracy + 1;
        fprintf(fid, 'recognition correct!\n');
    else
        fprintf(fid, 'recognition wrong to %s\n', cell2mat(train_face_name{min_idx(i),1}));
    end
end
fclose(fid);
accuracy = accuracy / test_face_num;