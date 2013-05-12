% clear all;
% close all;

comp_num = 5;
[projected_face, matrix_pca, col_mean] = train_stage_pca('.\ORLTrain', 'label_orl.txt', 100);
accuracy = zeros(15, 1);
for comp_num = 5 : 20
    accur_tmp = test_stage_pca('.\ORLTest', projected_face, matrix_pca, col_mean, comp_num);
    [accuracy(comp_num - 5 + 1)] = accur_tmp;
end
fprintf('The accuracy of test is: %f\n', accuracy);