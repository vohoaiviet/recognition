function [encode_image] = GridEncode(input_image, height, width, ratio)
%GRIDENCODE Efficiently encode to form feature-arrays for further process
%input_image      ---the input image
%height      ---the height of the input image
%width      ---the width of the input image
%ratio      ---downsample number


%% program start
% definite the encode image
en_height = floor((height + 3) / ratio);
en_width = floor((width + 3) / ratio);
encode_image = zeros(en_height, en_width);

% get the encode image
for i = 1 : en_height
    for j = 1 : en_width
        ii = (i - 1) * 4 + 1;
        jj = (j - 1) * 4 + 1;
        end_h = ii + 4; end_w = jj + 4;
        %careful for the last block
        if (end_h > height) 
            end_h = height; end
        if (end_w > width) 
            end_w = width; end
        %the mean of the locak block as the feature matrix
        local_block = input_image(ii : end_h, jj : end_w);
        encode_image(i, j) = mean(local_block(:));
    end
end