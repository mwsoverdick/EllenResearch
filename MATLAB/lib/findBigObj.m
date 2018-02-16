function [B, BW] = findBigObj(img,RGB)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    if nargin == 1
        RGB = [50 50 50];
    end
    if length(RGB) ~= 3
        error('RGB threshold must be a 1x3 matrix');
    end
    
    BW = imfill(roirgb(img, RGB(1), RGB(2), RGB(3)), 'holes');
        
        % Isolate primary object (filter 3)
    B = bwboundaries(BW, 8, 'noholes');  
    [~,idx] = max(cellfun('length', B));
    
        % Delete unecessary objects
    B = B{idx};
end

