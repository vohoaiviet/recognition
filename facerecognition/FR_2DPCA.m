clear all;
close all;

[projected_face, matrix_2dpca, train_face_name] = train_stage_2dpca('.\ORLTrain', 'label_orl.txt');
[accuracy] = test_stage_2dpca('.\ORLTest', projected_face, matrix_2dpca, train_face_name);
fprintf('The accuracy of test is: %f\n', accuracy);