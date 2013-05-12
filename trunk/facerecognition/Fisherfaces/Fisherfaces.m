clear all;
close all;

comp_num = 20;
accuracy = zeros(20, 1);
[fisherfaces, pca_matrix, fld_matrix, face_label, row_mean] = train_stage_fisherfaces('.\ORLTrain', 'label_orl.txt');
for comp_num = 1 : 20
    accuracy(comp_num) = test_stage_fisherfaces('.\ORLTest', fisherfaces, pca_matrix, fld_matrix, face_label, comp_num, row_mean);
end

for i = 1 : 20
    fprintf('Dim: %d, Accuracy: %f\n', i, accuracy(i));
end
disp('recognition all test faces successfully!');