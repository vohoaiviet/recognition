clear all;
close all;

dir_path = '.\train_cross_1\*.tiff';
filename = dir(dir_path);
file_num = length(filename);
if (file_num == 0)
    disp('Error! no train images.');
    return
end

fid = fopen('label_cross_1.txt', 'wt');
for i = 1 : file_num
    %fprintf('%s\n', filename(i).name);
    name = filename(i).name;
    fprintf(fid, '%s,', name);
    
    switch name(4:5)
        case 'AN'
            fprintf(fid, 'angry\n');
        case 'DI'
            fprintf(fid, 'digust\n');
        case 'FE'
            fprintf(fid, 'fear\n');
        case 'HA'
            fprintf(fid, 'happy\n');
        case 'NE'
            fprintf(fid, 'neutral\n');
        case 'SA'
            fprintf(fid, 'sad\n');
        case 'SU'
            fprintf(fid, 'surprised\n');
        otherwise
            disp('Unkown facial expression!');
            return;
    end
end
fclose(fid);