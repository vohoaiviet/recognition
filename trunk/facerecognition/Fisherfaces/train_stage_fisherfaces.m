function [fisherfaces, pca_matrix, fld_matrix, face_label, row_mean] = train_stage_fisherfaces(train_face_path, label_file_name)
%% TRAIN_STAGE is the training stage of face recognition system
%train_face_path      ---is the training face folder
%label_file_name      ---is the label file name
%fisherfaces      ---the projected data after PCA and FLD
%pca_matrix      ---PCA projected matrix
%fld_matrix      ---FLD projected matrix
%train_face_name      ---train face name used to calculating accuracy


%% initialize
[~, train_face_name, train_face_num, face_label]= Initialize(train_face_path, label_file_name);
class_num = 40;

%% read images
disp('Train stage: load image and process');
 
train_image = zeros(112 * 92, train_face_num);
for i = 1 : train_face_num
     %read train image
     file_name = cell2mat(train_face_name{i,1});
     fprintf('Loading train image : %s...\n', file_name);
     image = double(imread(file_name));
     train_image(:, i) = image(:);
end


%% generate class label
class_label = uint8(zeros(train_face_num, 1));
for i = 1 : train_face_num
    label = cell2mat(face_label{1, 2}(i));
    class_label(i) = uint8(str2double(label(2 : end)));
    fprintf('face label : %s, class_label(%d): %d\n', label, i, class_label(i));
end


%% apply PCA
[eigenfaces, pca_matrix, row_mean] = PCA(train_image, 40);


%% apply FLD
[fld_matrix, fisherfaces] = FLD(eigenfaces, class_label, class_num);