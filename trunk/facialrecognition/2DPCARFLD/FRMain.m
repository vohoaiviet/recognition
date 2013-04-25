% clear all;
% close all;

%% facial expression recognition main program

accuracy = zeros(10, 2);
rfld_num = 20;
for set_idx = 7 : 7
    for class_num = 7 : 7
        train_set_name = ['.\train_set', num2str(set_idx), '_', num2str(class_num)];
        test_set_name = ['.\test_set', num2str(set_idx), '_', num2str(class_num)];
        [rfld_projected, pca_matrix1, rfld_matrix, class_label] = train_stage(train_set_name, class_num, rfld_num);
        [accuracy(set_idx, class_num - 5), res_one_inc, res_two_inc] = test_stage(test_set_name, rfld_projected, pca_matrix1, rfld_matrix, class_label, class_num, rfld_num);
        %res = test_stage_pca_fld(test_set_name, fld_projected, pca_matrix1, fld_matrix, class_label, ratio, class_num);
    end
end