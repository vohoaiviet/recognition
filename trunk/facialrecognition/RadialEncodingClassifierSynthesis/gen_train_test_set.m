clear all;
close all;

% name of japanese female
name = cell(10, 1);
cell{1} = 'KA';
cell{2} = 'KL';
cell{3} = 'KM';
cell{4} = 'KR';
cell{5} = 'MK';
cell{6} = 'NA';
cell{7} = 'NM';
cell{8} = 'TM';
cell{9} = 'UY';
cell{10} = 'YM';

% person-independent cross-validation strategy
jaffe_dir = dir('.\jaffe\*.tiff');
dir_length = length(jaffe_dir);

for set_id = 1 : 10
    train_set_name = ['.\train_set', num2str(set_id)];
    test_set_name = ['.\test_set', num2str(set_id)];
    mkdir(train_set_name);
    mkdir(test_set_name);
    
    for file_id = 1 : dir_length
        if (~jaffe_dir(file_id).isdir())
            file_name = jaffe_dir(file_id).name;
            image = imread(['.\jaffe\', file_name]);
            
            if (strcmp(file_name(1 : 2), cell{set_id}))
                imwrite(image, [test_set_name, '\', file_name]);
            else
                imwrite(image, [train_set_name, '\', file_name]);
            end
        end
    end
end