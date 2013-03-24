function [lb, ws, hs] = partition(img, p, width, height)
%PARTITION partition the input image into local region.
%IMG is the facial region of each image. Assume P is the ratio of size of 
%size of input image to that of local region size to the , then the total 
%number of local blocks is (2p-1)^2 due to the assumed 50% overlap.

cnt = 1;
w = 1; 
h = 1;
ws = floor(width / p);
hs = floor(height / p);
lb = uint8(zeros(ws, hs, (2 * p - 1) ^ 2));

for i = 1 : (2 * p - 1)
    for j = 1 : (2 * p - 1)
        lb(:, :, cnt) = img(w : w + ws - 1, h : h + hs - 1);
        %figure, imshow(lb(:, :, cnt));
        h = h + floor(hs / 2);
        cnt = cnt + 1;
    end
    h = 1;
    w = w + floor(ws / 2);
end