clear all;
close all;

accuracy = zeros(20, 1);
[rfisherfaces, pca_matrix, rfld_matrix, train_face_name, row_mean] = train_stage_rfld('.\ORLTrain', 'label_orl.txt');
for comp_num = 1 : 20
    temp = test_stage_rfld('.\ORLTest', rfisherfaces, pca_matrix, rfld_matrix, train_face_name, comp_num, row_mean);
    accuracy(comp_num) = temp;
end

for i = 1 : 20
    fprintf('Dim: %d, Accuracy: %f\n', i, accuracy(i));
end
disp('recognition all test faces successfully!');