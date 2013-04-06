function [projected_face, matrix_pca] = train_stage_pca(train_face_path, label_file_name)
%% TRAIN_STAGE is the training stage of face recognition system
%train_face_path      ---is the training face folder
%label_file_name      ---is the label file name


%% initialize
[~, train_face_name, train_face_num]= Initialize(train_face_path, label_file_name);

%% read image and apply Gabor Filter
disp('Train stage: load image and process');
 
train_image = zeros(train_face_num, 112 * 92);
for i = 1 : train_face_num
     %read train image
     file_name = cell2mat(train_face_name{i,1});
     fprintf('Loading train image : %s...\n', file_name);
     origin_face = imread(file_name);
     train_image(i, : ) = origin_face(:);
end

%% apply PCA
[pca_mapped_image, matrix_pca] = PCA(train_image, 160);
projected_face = pca_mapped_image;