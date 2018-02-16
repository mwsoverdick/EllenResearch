function [BW, B, edges] = cropObj(img, RGB, Padding)
%cropObj Crop object from image
%   Returns ROI of main object in image and a vector of its boundary
%   
%   ARGUMENTS:
%       img - image to crop
%       RGB - 1x3 matrix of RGB thresholds
%       Padding - Padding for object
%
%   RETURNS:
%       BW - ROI mask of object
%       B - Vector of object boundary
%   
%   USES:
%       cropObj(img) - RGB defaults to [50 50 50], Padding to 0
%       cropObj(img, RGB, Padding) - fully customized

        % Parse inputs
    if nargin == 1
        Padding = 0;
    elseif nargin < 3
        error('Too few input arguments');
    elseif nargin > 3
        error('Too many input arguments');
    elseif nargin > 1
        if length(Padding) ~= 1
            error('Padding should only have a length of 1');
        end
    end
    
    % Main code 
        % Find biggest object
    [B, BW] = findBigObj(img);
    
        % Create Empty mask
    msize = size(img);
    mask=false(msize(1:2));
    
        % Convert boundary to mask
    for i = 1:length(B)
        ind = B(i,:);
        mask(ind(1),ind(2)) = 1;
    end
    
        % Fill mask and crop
    [BW, B, edges] = croproi(imfill(mask,'holes'), B, Padding);
end

