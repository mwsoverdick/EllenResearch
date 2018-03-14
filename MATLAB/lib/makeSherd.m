function [osherd, blank] = makeSherd(image, isherd, trademark, coords,TMsum, TMthresh)
%makeSherd Makes a sherd
%   No detailed explanation yet

        % Default for tmpct is 100
    if nargin < 5
        TMthresh = 0;
    else
    end
    
        % Translate sherd by ajusting window of ceramic
    s = size(isherd);
    TL = coords(2) - ceil(s(1)/2)+1; % Top left
    TR = coords(2) + floor(s(1)/2);  % Top right
    BL = coords(1) - ceil(s(2)/2)+1; % Bottom Left
    BR = coords(1) + floor(s(2)/2);  % Bottom Right
    
        % Pre allocate canvas
    osherd     = uint8(zeros(length(TL:TR), length(BL:BR), 3));

        % Store sherd within canvas
    osherd(:,:,1) = image(TL:TR,BL:BR,1).*isherd;
    osherd(:,:,2) = image(TL:TR,BL:BR,2).*isherd;
    osherd(:,:,3) = image(TL:TR,BL:BR,3).*isherd;
    
        % Check if trademark is in image
    TMchk = trademark(TL:TR,BL:BR).*isherd;

        % See if image qualifies as "Blank"
    if sum(sum(TMchk))/TMsum <= TMthresh
        blank = true;
    else
        blank = false;
    end
end

