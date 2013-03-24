function [projected_face, matrix_pca] = train_stage(train_face_path, label_file_name)
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
     fprintf('Loading train image # %d...\n', i);
     file_name = cell2mat(train_face_name{i,1});
     origin_face = imread(file_name);
     
%      %perform gabor filter
%      [height, width] = size(origin_face);
%      filter_output = GaborFilter(origin_face, height, width);
%     
%      %perform grid encode
%      encode_face = zeros(24, 25 * 25);
%      for ii = 1 : 24
%          encode_image = GridEncode(filter_output(:, :,ii), height, width, 4);
%          encode_face(ii, :) = encode_image(:);
%      end
%      
     train_image(i, : ) = origin_face(:);
end

%% apply PCA and RFLD
[pca_mapped_image, matrix_pca] = PCA(train_image, 11);
projected_face = pca_mapped_image;

% inverse_pca_mapped_image = pca_mapped_image';
% 
% %generate class label number
% class_label = zeros(train_face_num, 1);
% for i = 1 : train_face_num
%     file_name = cell2mat(train_face_name{i, 1});
%     class_label(i, 1) = file_name(8) - 'A' + 1;
% end
% [matrix_rfld, projected_face] = RecursiveFLD(inverse_pca_mapped_image, class_label, train_face_num, 20);