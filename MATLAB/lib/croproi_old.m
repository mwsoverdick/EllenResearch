function [oBW, coords] = croproi_old(iBW,padding)
%croproi Crop ROI to remove dead space
%   ARGUMENTS:
%   iBW - input BW to crop
%   padding - amount of padding to add
%
%   RETURNS:
%   oBW - cropped ROI
%   coords - coordinates of top, bottom, left, and right of ROI
tic
    % Initialize coordinates
coords = zeros(4,2);

    % Compute size of iBW
[~, N] = size(iBW);

    % Find left
[y,x] = find(iBW~=0,1,'first');
coords(1,:) = [x-padding,y];

    % Find right
[y,x] = find(iBW~=0,1,'last');
coords(2,:) = [x+padding,y];

    % Find top
[x,y] = find(rot90(iBW)~=0,1,'first');
coords(3,:) = [N-x,y-padding];

    % Find bottom
[x,y] = find(rot90(iBW)~=0,1,'last');
coords(4,:) = [N-x,y+padding];

    % Calculate width and height
height = coords(4,2)-coords(3,2)+1;
width = coords(2,1)-coords(1,1)+1;

    % Crop
oBW = imcrop(iBW, [coords(1,1), coords(3,2), width, height]);
  toc

