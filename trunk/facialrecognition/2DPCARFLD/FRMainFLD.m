% clear all;
% close all;

%% facial expression recognition main program

accuracy = zeros(10, 2);
wei_num = zeros(10, 2);
for set_idx = 1 : 10
    for class_num = 6 : 7
        train_set_name = ['.\train_set', num2str(set_idx), '_', num2str(class_num)];
        test_set_name = ['.\test_set', num2str(set_idx), '_', num2str(class_num)];
        [fld_projected, pca_matrix1, fld_matrix, class_label] = train_stage_fld(train_set_name, class_num);
        [accuracy(set_idx, class_num - 5),  wei_num(set_idx, class_num - 5)] = test_stage_fld(test_set_name, fld_projected, pca_matrix1, fld_matrix, class_label, class_num);
        %res = test_stage_pca_fld(test_set_name, fld_projected, pca_matrix1, fld_matrix, class_label, ratio, class_num);
    end
end