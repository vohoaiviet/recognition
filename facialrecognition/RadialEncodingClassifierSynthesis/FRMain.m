clear all;
close all;

%% facial expression recognition main program

ratio = 3;
[facial_feature, fld_projected, pca_matrix1, fld_matrix, pca_matrix2, rfld_matrix, class_label] = train_stage('.\train_set1', ratio);
accuracy = test_stage('.\test_set1', facial_feature, fld_projected, pca_matrix1, fld_matrix, pca_matrix2, rfld_matrix, class_label, ratio);

fprintf('The accuracy is %f\n', accuracy);