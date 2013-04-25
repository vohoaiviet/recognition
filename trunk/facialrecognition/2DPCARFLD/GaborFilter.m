function filter_output = GaborFilter(input_image, gabor_mask)
%% GabirFilter apply Gabor filter to the input image
%input_image      ---input image for the Gabor filter
%gabor_mask      ---Gabor filter mask
%filter_output      ---Gabor filter output


%% initialize
input_image = double(input_image);
[height, width] = size(input_image);
filter_output = zeros(height, width, 24);

% perform convolution with the filter
for i = 1 : 3
    for j = 1 : 8
        template = double(gabor_mask{i, j});
        filter_output(:, :, (i - 1) * 8 + j) = mat2gray(conv2(input_image, template, 'same'));
    end
end