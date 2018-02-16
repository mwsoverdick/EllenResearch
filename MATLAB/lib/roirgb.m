function BW = roirgb(img,tR,tG,tB)
%ROIRGB Creat region of interest based on RGB thresholds
%   Arguments:
%       img - The image to process
%       tR  - Threshold for RED (everything below threshold deleted)
%       tG  - Threshold for GREEN (everything below threshold deleted)
%       tB  - Threshold for BLUE (everything below threshold deleted)
%   Returns:
%       BW  - ROI map of image (uint8)

    % Break image into channels
imgR = img(:,:,1);
imgG = img(:,:,2);
imgB = img(:,:,3);

    % Red Channel
imgR(imgR > tR) = 255;
imgR(imgR < tR) = 0;

    % Green Channel
imgG(imgG > tG) = 255;
imgG(imgG < tG) = 0;

    % Blue Channel
imgB(imgB > tB) = 255;
imgB(imgB < tB) = 0;

    % Create ROI
BW = imgR + imgG + imgB;
BW(BW>255) = 255;

BW = uint8(BW);
end

