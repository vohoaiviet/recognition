clear all;
close all;

% name of japanese female
name = cell(10, 1);
name{1} = 'KA';
name{2} = 'KL';
name{3} = 'KM';
name{4} = 'KR';
name{5} = 'MK';
name{6} = 'NA';
name{7} = 'NM';
name{8} = 'TM';
name{9} = 'UY';
name{10} = 'YM';

% person-independent cross-validation strategy
jaffe_dir = dir('.\jaffe\*.tiff');
dir_length = length(jaffe_dir);

% for set_id = 1 : 10
%     train_set_name = ['.\train_set', num2str(set_id)];
%     test_set_name = ['.\test_set', num2str(set_id)];
%     mkdir(train_set_name);
%     mkdir(test_set_name);
%     
%     for file_id = 1 : dir_length
%         if (~jaffe_dir(file_id).isdir())
%             file_name = jaffe_dir(file_id).name;
%             image = imread(['.\jaffe\', file_name]);
%             
%             if (strcmp(file_name(1 : 2), cell{set_id}))
%                 imwrite(image, [test_set_name, '\', file_name]);
%             else
%                 imwrite(image, [train_set_name, '\', file_name]);
%             end
%         end
%     end
% end

for set_id = 1 : 10
    train_set_name_6 = ['.\train_set', num2str(set_id), '_6'];
    train_set_name_7 = ['.\train_set', num2str(set_id), '_7'];
    test_set_name_6 = ['.\test_set', num2str(set_id), '_6'];
    test_set_name_7 = ['.\test_set', num2str(set_id), '_7'];
    mkdir(train_set_name_6);
    mkdir(train_set_name_7);
    mkdir(test_set_name_6);
    mkdir(test_set_name_7);
    
    for file_id = 1 : dir_length
        if (~jaffe_dir(file_id).isdir())
            file_name = jaffe_dir(file_id).name;
            image = imread(['.\jaffe\', file_name]);
            
            if (strcmp(file_name(1 : 2), name{set_id}))
                imwrite(image, [test_set_name_7, '\', file_name]);
                if (~strcmp(file_name(4 : 5), 'NE'))
                    imwrite(image, [test_set_name_6, '\', file_name]);
                end
            else
                imwrite(image, [train_set_name_7, '\', file_name]);
                if (~strcmp(file_name(4 : 5), 'NE'))
                    imwrite(image, [train_set_name_6, '\', file_name]);
                end
            end
        end
    end
end