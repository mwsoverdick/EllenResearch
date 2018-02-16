function edges = boundEdges(B)
%boundEdges find edges of a ROI
%   ARGUMENTS:
%       B - BWboundary output
%
%   RETURNS:
%       edges - [top, bottom, left, right]

    % Initialize bounds vector
edges = zeros(1,4);    % edges = [top, bottom, left, right]

    % Find top
edges(1) = min(B(:,1));

    % Find bottom
edges(2) = max(B(:,1));

    % Find left
edges(3) = min(B(:,2));

    % Find right
edges(4) = max(B(:,2));

end

