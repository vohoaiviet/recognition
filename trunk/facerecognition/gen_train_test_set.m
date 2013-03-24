%% generate train set and test set using ORL face database
clear all;
close all;

% get ORL database file
ORL_DB = dir('.\ORL');
[n, ~] = size(ORL_DB);

for i = 1 : n
    folder_name = ORL_DB(i).name;
    if (folder_name(1) == 's')
        sub_folder = dir(['.\ORL\', folder_name]);
        total_image = length(sub_folder);
        for j = 1 : total_image
            if (~sub_folder(j).isdir)
                if (strcmp(sub_folder(j).name(end - 3 : end), '.bmp'))
                    image = imread(['.\ORL\', folder_name, '\', sub_folder(j).name]);
                end
                if (sub_folder(j).name(1) <= '5' && sub_folder(j).name(2) == '.')
                    imwrite(image, ['.\ORLTrain\', folder_name, '(', sub_folder(j).name(1 : end - 4), ').bmp']);
                else
                    imwrite(image, ['.\ORLTest\', folder_name, '(', sub_folder(j).name(1 : end - 4), ').bmp']);
                end
            end
        end
    end
end