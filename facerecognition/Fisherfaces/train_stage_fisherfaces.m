function [pca_projected_face, pca_matrix, train_face_name] = train_stage_fisherfaces(train_face_path, label_file_name)
%function [pca_fld_projected_face, pca_matrix, fld_matrix, train_face_name] = train_stage_fisherfaces(train_face_path, label_file_name)
%% TRAIN_STAGE is the training stage of face recognition system
%train_face_path      ---is the training face folder
%label_file_name      ---is the label file name
%pca_fld_projected_face      ---the projected data after PCA and FLD
%pca_matrix      ---PCA projected matrix
%fld_matrix      ---FLD projected matrix
%train_face_name      ---train face name used to calculating accuracy


%% initialize
[~, train_face_name, train_face_num, face_label]= Initialize(train_face_path, label_file_name);


%% read images
disp('Train stage: load image and process');
 
train_image = zeros(train_face_num, 112 * 92);
for i = 1 : train_face_num
     %read train image
     file_name = cell2mat(train_face_name{i,1});
     fprintf('Loading train image : %s...\n', file_name);
     image = double(imread(file_name));
     train_image(i, :) = image(:);
end


%% generate class label
class_label = zeros(train_face_num, 1);
for i = 1 : train_face_num
    label = cell2mat(face_label{1, 2}(i));
    fprintf('face label : %s...\n', label);
    class_label(i) = str2double(label(2 : end));
end


%% apply PCA
% [pca_projected_face, pca_matrix] = PCA(train_image, train_face_num - 40);
[pca_matrix, pca_projected_face] = princomp(train_image, 'econ');
pca_matrix = pca_matrix(:, 1 : train_face_num - 40);
pca_projected_face = pca_projected_face(:, 1 : train_face_num - 40);


%% apply FLD
%[fld_matrix, pca_fld_projected_face] = FLD(pca_projected_face', class_label, 40);