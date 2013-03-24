%% Test Fisher Linear Discriminant for two classes
clear all;
close all;


%% Generate two class
%  XX = load('X1.mat');
%  YY = load('Y1.mat');
%  X1 = XX.X1;
%  Y1 = YY.Y1;
%  XX = load('X2.mat');
%  YY = load('Y2.mat');
%  X2 = XX.X2;
%  Y2 = YY.Y2;

%  X1 = int8(normrnd(40,10,[200,1]));
%  Y1 = int8(normrnd(40,10,[200,1]));
%  Z1 = int8(normrnd(40,10,[200,1]));
%  A1 = int8(normrnd(40,10,[200,1]));
%  w1=[X1, Y1, Z1, A1]';
 
dim = 12;
 w1 = zeros(dim, 200);
 w2 = zeros(dim, 100);
 for i = 1 : dim
     XX = int8(normrnd(40, 10, [200, 1]));
     YY = int8(normrnd(5, 10, [100, 1]));
     w1(i, :) = XX';
     w2(i, :) = YY';
 end
 
%  X2 = int8(normrnd(5 ,10,[100,1]));
%  Y2 = int8(normrnd(0 ,10,[100,1]));
%  Z2 = int8(normrnd(0 ,10,[100,1]));
%  A2 = int8(normrnd(0 ,10,[100,1]));
%  w2=[X2, Y2, Z2, A2]';
 
 % class label array
 class_label = int8(ones(300, 1));
 for i = 201 : 300
     class_label(i) = 2;
 end
 % class_num is the number of class
 class_num = 2;
 
 % sample is the samples X1, X2, ..., X300
 sample = zeros(dim, 300);
 sample(:, 1 : 200) = w1;
 sample(:, 201 : 300) = w2;
 
 %% Get the projected matrix
 W= RecursiveFLD(sample, class_label, class_num);
 
%[W, V, Sw, Sb, M1, M2] = FisherLD(sample, class_label, class_num);
%  rankSw = rank(Sw);
%  rankSb = rank(Sb);
%  
%  W = Sw \ (M1 - M2);
%  
%  avg_sample1 = W' * M1;
%  avg_sample2 = W' * M2;
%  threshold = (avg_sample1 + avg_sample2) / 2;
%  
%  
% %% Draw the project line
%  figure('Name','Simulation FLD','NumberTitle','off');
%  plot(X1,Y1,'.r',X2,Y2,'.b');
%  
%  hold on;
%  grid;
%  
%  x = -40: 0.1: 80;
%  y = x*W(2)/W(1);
%  plot(x,y,'g');
% 
%  
%  %% You can input 50 sample for testing
%  for i=1:50
%     [x,y]=ginput(1);
%     test_sample = [x, y]';
%     hold on
%     plot(x,y,'m^');
%     if (W' * test_sample > threshold)
%         disp('It belong to the first class');
%     else
%         disp('It belong to the second class');
%     end
% end