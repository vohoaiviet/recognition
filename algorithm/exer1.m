%% Learn how to use the save command by exercising
clear all;
close all;

% data definition
s1 = sin(pi / 4);
c1 = cos(pi / 4);
c2 = cos(pi / 2);
str = 'hello world';

% save command
save matlab.mat
save data.mat s1 c1 c2 str
save numdata.mat s1 c1
save strdata.mat str
save allcos.dat c1 c2 -ASCII