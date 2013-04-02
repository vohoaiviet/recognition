clear all;
close all;

[pca_fld_projected_face, pca_matrix, train_face_name] = train_stage_fisherfaces('.\ORLTrain', 'label_orl.txt');
%[pca_fld_projected_face, pca_matrix, fld_matrix, train_face_name] = train_stage_fisherfaces('.\ORLTrain', 'label_orl.txt');
%accuracy = test_stage_fisherfaces('.\ORLTest', pca_fld_projected_face, pca_matrix, fld_matrix, train_face_name);
accuracy = test_stage_fisherfaces('.\ORLTest', pca_fld_projected_face, pca_matrix, train_face_name);
fprintf('The accuracy of test is: %f\n', accuracy);
disp('recognition all test faces successfully!');