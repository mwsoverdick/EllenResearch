function [oBW, B, edges] = croproi(iBW, B, pad)
%croproi Crop ROI to remove dead space
%   ARGUMENTS:
%       iBW - input BW to crop
%       pad - amount of padding to add
%       B - object boundaries
%
%   RETURNS:
%       oBW - cropped ROI
%       B - cropped boundary
%       edges - edges [top, bottom, left, right] [Ymin Ymax Xmin Xmax]

    % Initialize bounds vector
edges = boundEdges(B);

    % Crop
oBW = imcrop(iBW, [edges(3) - pad, edges(1) - pad,...
             edges(4)-edges(3) + 2*pad, edges(2)-edges(1) + 2*pad]);
         
    % Adjust boundary
B(:,1) = B(:,1)-edges(1)+1+pad;
B(:,2) = B(:,2)-edges(3)+1+pad;

    % Adjust edges
edges(1:2) = edges(1:2)-edges(1)+1+pad;
edges(3:4) = edges(3:4)-edges(3)+1+pad;