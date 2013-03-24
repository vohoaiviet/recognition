clear all;
close all;

[projected_face, matrix_pca] = train_stage_pca('.\ORLTrain', 'label_orl.txt');
[accuracy] = test_stage_pca('.\ORLTest', projected_face, matrix_pca);
fprintf('The accuracy of test is: %f\n', accuracy);