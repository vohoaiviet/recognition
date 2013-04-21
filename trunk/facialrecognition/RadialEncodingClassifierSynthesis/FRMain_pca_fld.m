% clear all;
% close all;

%% facial expression recognition main program

ratio = 4;
% [fld_projected, pca_matrix1, fld_matrix, class_label] = train_stage_pca_fld('.\train_set6', ratio);
[accuracy] = test_stage_pca_fld('.\test_set6_6', fld_projected, pca_matrix1, fld_matrix, class_label, ratio);


temp_projected = fld_projected(:, :, 1);

fprintf('The accuracy is %f\n', accuracy);