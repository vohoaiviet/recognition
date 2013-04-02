function [feature_matrix, pixel_num] = RadialEncode(input_image, width, height)
%% RadialEncode encode Gabor filter ouput to form feature-matrice of size 18 X 5.
%input_image      ---the input image for radial encode
%width      ---the width of the input image
%height      ---the height of the input image
%feature_matrix      ---feature represention of local block
%pixel_num      ---the pixel num in each region



%% radial of the outermost circle of the radial grid
radial = floor(min(width, height) / 2);

% center of the radial grid cx, cy
cx = floor(width / 2);
cy = floor(height / 2);

% total pixel number in each grid
pixel_num = zeros(18, 5);
feature_matrix = zeros(18, 5);

% region for search 
beg_width = max(cx - radial, 1);
end_width = min(cx + radial, width);
beg_height = max(cy - radial, 1);
end_height = min(cy + radial, height);

% each pixel find its location on the grid and sum all pixel value for each
% region
for hei = beg_height : end_height
    for wid = beg_width : end_width
        % the distance from center
        dis = sqrt(double((wid - cx)^2) + (hei - cy)^2);
        if (dis > 0.0 && dis <= radial)
            % region along radial
            sector_r = min(floor(dis * 5 / radial) + 1, 5);
            % region along angle
            theta = acos((wid - cx) / dis);
            if hei > cy
                theta = 2 * pi - theta;
            end
            sector_a = min(floor(theta * 9 / pi) + 1, 18);
            % calculate pixel number and sum all pixel value for each
            % region
            pixel_num(sector_a, sector_r) = pixel_num(sector_a, sector_r) + 1;
            feature_matrix(sector_a, sector_r) = feature_matrix(sector_a, sector_r) + double(input_image(hei, wid));
        end
    end
end

% calculate average pixel value for each sector
for sector_a = 1 : 18
    for sector_r = 1 : 5
        if (pixel_num(sector_a, sector_r) == 0)
            feature_matrix(sector_a, sector_r) = 0;
        else
            feature_matrix(sector_a, sector_r) = feature_matrix(sector_a, sector_r) / pixel_num(sector_a, sector_r);
        end
    end
end