% generate the infomation of the train face
clear all;
close all;

% get train face number
train_face_path = '.\yale\*.bmp';
filename = dir(train_face_path);
file_num = length(filename);
if (file_num == 0)
    disp('Error! No train face.');
    return
end

% get train face name and indentity
fid = fopen('label_yale.txt', 'wt');
for i = 1 : file_num
    name = filename(i).name;
    fprintf(fid, '%s,%s\n', name, name(1));
end
fclose(fid);