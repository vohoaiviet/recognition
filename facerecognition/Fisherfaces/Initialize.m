function [success, train_face_name, train_face_num, face_label]= Initialize(train_face_path, face_label_name)
%% Initialize Initialization train face name and checking.
%train_face_path      ---train face path
%face_label_name      ---the infomation of trainning set
%success      ---whether initialization is successful.
%train_face_name      ---train face name
%train_face_num      ---the number of train face


%% check path and file name
fprintf('\nChecking training face path and initialization...\n');
% check whether train face folder is input
if (isempty(train_face_path))
    train_face_path = input('Please input the train face folder:', 's');
end

% check whether face label file name is input.
if (isempty(face_label_name))
    face_label_name = input('Please input the label file:', 's');
end


%% Initialize face name and lable file
% read face label file
fid = fopen(face_label_name);
face_label = textscan(fid, '%s %s', 'whitespace', ',');
fclose(fid);

% get train face
train_face_num = length(face_label{1, 1});
train_face_name = '';
for i = 1 : train_face_num
 	train_face_name{i, 1} = strcat(train_face_path, '\', face_label{1, 1}(i));
end


%% return parameters
success = 1;