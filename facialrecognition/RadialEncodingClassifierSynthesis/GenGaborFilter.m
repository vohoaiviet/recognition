function filter_mask = GenGaborFilter
%% GenGaborFilter generate 24 Gabor filters, three filter sizes and eight orientations
%filter_mask      ---Gabor filter mask


%% each element of filter_mask is a filter mask
filter_mask = cell(3, 8);

% three filter sizes, S = 11, 20, 29
size = 1;
for S = 11 : 9 : 29
    % see formulas (3)
    variance =  ceil(0.0036 * (S ^ 2) + 0.35 * S + 0.18);
    % see formulas (3)
    wavelen = variance / 0.8;
    gabor_mask = zeros(variance, variance);
    
    orient = 1;
    % eight orientations, from 0 to 7/8*pi in uniform steps of 1/8*pi
    for theta = 0 : pi / 8 : 7 * pi / 8;
        for x = -variance : variance
            for y = -variance : variance
                xPrime = x * cos(theta) + y * sin(theta);
                yPrime = -x * sin(theta) + y * cos(theta);
                gabor_mask(variance + x + 1, variance + y + 1) = exp(-0.5 * (xPrime ^ 2 + 0.25 * yPrime ^ 2) ...
                    / (variance ^ 2)) * cos(2 * pi * xPrime / wavelen);
            end
        end
        %figure, imshow(gaborMask);
        filter_mask{size, orient} = gabor_mask;
        orient = orient + 1;
    end
    size = size + 1;
end