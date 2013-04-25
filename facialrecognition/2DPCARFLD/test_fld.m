%% Test Fisher Linear Discriminant for two classes
clear all;
close all;


%% generate two classes for test
% w1 is 200 samples, each sample has 2 dimensions(x1, y1). x1 and y1 is
% random number chosen from a normal distribution with mean 40 and standard
% deviation 10.
X1 = int8(normrnd(40,10,[200,1]));
Y1 = int8(normrnd(40,10,[200,1]));
w1=[X1, Y1]';

% w2 is 100 samples, each sample has 2 dimensions(x2, y2). x2 is random
% number chosen from a normal distribution with mean 5 and standard
% deviation 10, y2 is random number chosen from a normal distribution with
% mean 0 and standard deviation 10.
% deviation 10.
X2 = int8(normrnd(5 ,10,[100,1]));
Y2 = int8(normrnd(0 ,10,[100,1]));
w2=[X2, Y2]';
 
% generate class label array
class_label = int8(ones(300, 1));
for i = 201 : 300
    class_label(i) = 2;
end

% class_num is the number of class
class_num = 2;
 
% sample is the samples x1, x2, ..., x300
sample = zeros(2, 300);
sample(:, 1 : 200) = w1;
sample(:, 201 : 300) = w2;


%% get the projected matrix
[W, V, Sw, Sb, M1, M2, W_t, WW] = FLD(sample, class_label, class_num);
% rankSw = rank(Sw);
% rankSb = rank(Sb);

W_1 = Sw \ (M1 - M2);

% threshold for classification
avg_sample1 = W' * M1;
avg_sample2 = W' * M2;
threshold = (avg_sample1 + avg_sample2) / 2;
 

%% draw samples and the project line
figure('Name','Simulation FLD','NumberTitle','off');
plot(X1, Y1, '.r', X2, Y2, '.b');
 
hold on;
grid;

W = W / norm(W);
W_1 = W_1 / norm(W_1);

x = -40 : 0.1 : 80;
y = x * W(2) / W(1);
plot(x, y, 'g');

%% for two classes, other methods can be used for seeking the direction. See formula (3.49) and (3.56)
% y_1 = x * W_1(2) / W_1(1);
% plot(x, y_1, 'b');
% 
% y_2 = x * W_t(2) / W_t(1);
% plot(x, y_2, 'r');


%% you can input at most 50 samples for test, the result will show in the Command Window.
for i = 1 : 50
    [x, y] = ginput(1);
    test_sample = [x, y]';
    hold on
    plot(x, y, 'm^');
    if (W' * test_sample > threshold)
        disp('It belong to the first class');
    else
        disp('It belong to the second class');
    end
end