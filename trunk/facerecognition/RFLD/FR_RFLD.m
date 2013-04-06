clear all;
close all;

[pca_rfld_projected_face, pca_matrix, rfld_matrix, train_face_name] = train_stage_rfld('.\ORLTrain', 'label_orl.txt');
accuracy = test_stage_rfld('.\ORLTest', pca_rfld_projected_face, pca_matrix, rfld_matrix, train_face_name);
fprintf('The accuracy of test is: %f\n', accuracy);
disp('recognition all test faces successfully!');