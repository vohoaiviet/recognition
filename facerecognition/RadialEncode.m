function [featurematrice, SUM, pixelNum] = RadialEncode(input_image, height, width)
%RADIALENCODE efficiently encode to form feature-arrays for further process
%IM is the result from Gabor filter, W is the width and H is the height.

radial = floor(min(w, h) / 2);

%center of the radial grid cx, cy
cx = floor(w / 2);
cy = floor(h / 2);

pixelNum = zeros(18, 5);
featurematrice = zeros(18, 5);

begWidth = cx - radial + 1;
endWidth = cx + radial - 1;
begHeight = cy - radial + 1;
endHeight = cy + radial - 1;

for i = begWidth : endWidth
    for j = begHeight : endHeight
        dis = sqrt(double((i - cx)^2) + (j - cy)^2);
        if (dis >= 0.0 && dis <= radial && j ~= cy)
            sectorR = floor(dis / radial * 5) + 1;
            if sectorR > 5
                sectorR = 5;
            end
            
            theta = acos((j - cy) / dis);
            if i > cx
                theta = 2 * pi - theta;
            end
            
            sectorA = floor(theta * 9 / pi) + 1;
            if sectorA > 18
                sectorA = 18;
            end
            if (sectorA == 5 && sectorR == 1)
                fprintf('i = %d, j = %d, sectorA = %d, sectorR = %d\n', i, j, sectorA, sectorR);
            end
            pixelNum(sectorA, sectorR) = pixelNum(sectorA, sectorR) + 1;
            featurematrice(sectorA, sectorR) = featurematrice(sectorA, sectorR) + double(im(i, j));
        end
    end
end

SUM = featurematrice;
for i = 1 : 18
    for j = 1 : 5
        if (pixelNum(i, j) == 0)
            featurematrice(i, j) = 0;
        else
            featurematrice(i, j) = featurematrice(i, j) / pixelNum(i, j);
        end
    end
end