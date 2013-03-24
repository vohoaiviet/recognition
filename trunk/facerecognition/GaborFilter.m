function [filter_output] = GaborFilter(input_face, height, width)
%% GABORFILTER perform the gabor filter on the input face.
%input_face      ---input image
%height      ---the height of the image
%width      ---the width of the image
%filter_output      ---the result of the gabor filter on the input image


%% initialize some parameter
filter_size = 3; filter_direction = 8;
gabor_filters = GenGaborFilter(filter_size, filter_direction);
input_face = double(input_face);
%filter_output = zeros(height, width, filter_size * filter_direction);
filter_output = zeros(height, width, 24);

% perform the convolution on the input image
for i = 1 : filter_size
    for j = 1 : filter_direction
        filter = double(gabor_filters{i, j});
        output = mat2gray(conv2(input_face, filter, 'same'));
        filter_output(:, :, (i - 1) * 8 + j) = output;
    end
end

%mean of the gabor output