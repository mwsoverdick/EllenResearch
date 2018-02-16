function BW = drawTM(img)
% drawTM draw the trademark on a ceramic
%
%   This is proprietary, so I'll write this later. Good development costs
%   money, I'm doing this for free.

%% Setup
% suppress warnings
warning('off','images:imshow:magnificationMustBeFitForDockedFigure');
warning('off','images:initSize:adjustingMag');

%% Read image
    % User feedback
fprintf('Please trace trademark perimeter, be as accurate as possible.');

%% Show image
    % Show image
imshow(img);

%% Generate sherds
dims = size(img);
BW = uint8(zeros(dims(1),dims(2)));
BW(:,:,1) = uint8(roipoly(img));

    % Show final image
%img(:,:,1) = img(:,:,1).*uint8(~BWs(:,:,1));
img(:,:,2) = img(:,:,2).*uint8(~BW(:,:,1));
img(:,:,3) = img(:,:,3).*uint8(~BW(:,:,1));
imshow(img)

%% finish
    % User feedack for completion
fprintf('Trademark traced.\n\r');
