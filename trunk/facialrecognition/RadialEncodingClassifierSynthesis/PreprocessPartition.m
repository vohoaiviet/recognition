function [local_blocks, lbw, lbh, block_num, uniform_image] = PreprocessPartition(facial_image, width, height, ratio)
%% Preprocesspartition achieve a uniform image size of 164 X 127and divide image into several local regions.
%facial_image      ---the origin facial image
%width      ---the width of faical image
%height      ---the height of facial image
%ratio      ---the ratio of size of the input image to that of the local
%region
%local_blocks      ---local regions of image
%lbw      ---the width of local regions
%lbh      ---the height of local regions


%% preprocessing
cx = width / 2;
cy = height / 2;
uniform_image = facial_image(cy - 71:cy + 92, cx - 60:cx + 66);


%% partition
block_num = 1;
w = 1; 
h = 1;
temp = 2 * ratio - 1;

lbw = floor(127 / ratio);
lbh = floor(164 / ratio);
local_blocks = uint8(zeros(lbh, lbw, temp ^ 2));

% the neighboring local regions are designed to have 50% overlap
for i = 1 : temp
    for j = 1 : temp
        local_blocks(:, :, block_num) = uniform_image(h : h + lbh - 1, w : w + lbw - 1);
        w = w + floor(lbw / 2);
        block_num = block_num + 1;
    end
    w = 1;
    h = h + floor(lbh / 2);
end
block_num = block_num - 1;