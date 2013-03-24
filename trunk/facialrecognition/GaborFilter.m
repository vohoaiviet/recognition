function [fmatrix] = GaborFilter(img, w, h)
%% GABORFILTER perform the gabor filter
%%MEANIMG      ---Mean of all the 24 result

%% ##################Apply 24 Gabor filter###################
gaborFilters = GenGaborFilter;
img = double(img);

fmatrix = zeros(90, 24);
cnt = 1;
for i = 1 : 3
    for j = 1 : 8
        filter = double(gaborFilters{i, j});
        output = mat2gray(conv2(img, filter, 'same'));
        resImg = radialencode(output, width, height);
        fmatrix(:, cnt) = resImg(:);
        cnt = cnt + 1;
        %figure, imshow(resImage);
    end
end