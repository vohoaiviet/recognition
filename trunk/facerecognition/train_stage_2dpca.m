function [projected_face, matrix_2dpca, train_face_name, eigenval] = train_stage_2dpca(train_face_path, label_file_name)
%% TRAIN_STAGE is the training stage of face recognition system
%train_face_path      ---is the training face folder
%label_file_name      ---is the label file name


%% initialize
[~, train_face_name, train_face_num]= Initialize(train_face_path, label_file_name);

%% read image and apply Gabor Filter
disp('Train stage: load image and process');
 
train_image = zeros(112, 92, train_face_num);
for i = 1 : train_face_num
     %read train image
     file_name = cell2mat(train_face_name{i,1});
     fprintf('Loading train image : %s...\n', file_name);
     train_image(:, :, i) = double(imread(file_name));
end

%% apply 2DPCA
[projected_face, matrix_2dpca, eigenval] = TDPCA(train_image, 10);