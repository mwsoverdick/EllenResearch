function oSherd = rotSherd(iSherd,angle, pad)
%ROTSHERD Rotates a sherd a certain angle

    % Assume padding is zero if not provided
if nargin == 2
    pad = 0;
else
end

    % Rotate ROI
rSherd = imrotate(iSherd, angle);

    % Find object
rB = findBigObj(rSherd);

    % Initialize bounds vector
edges = boundEdges(rB);

    % Crop
oSherd = imcrop(rSherd, [edges(3) - pad, edges(1) - pad,...
             edges(4)-edges(3) + 2*pad, edges(2)-edges(1) + 2*pad]);

end

