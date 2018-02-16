% TemplateSherder.m - create template sherds for developing ML database.
% Mitchell Overdick 11/19/2017

%% Configurable Parameters
    % Path to folder with images of sherds on black background
image_path	= '../../db/Template Sherds/Source';

    % Path to write sherd files to
shrd_path   = '../../db/Template Sherds/Processed';       

show        = 0;	% Show sherds as the process 0 for off, otherwise seconds for duration

%% Calibration Parameters
    % Detection Thresholds
tR      = 50;           % Red Threshold
tG      = 50;           % Green Threshold
tB      = 50;           % Blue Threshold

    % Image properties
iext	= 'jpg';        % File extension of images (no dot)

    % Output parameters
padding = 0;            % Padding for sherd (Pixels)
sext    = 'shrd';       % File extension of sherd (will be .mat format with special extension)

%% Setup
extl = length(iext)+1;  % Calculate file extension length

    % Add function library
addpath '../lib/'

    % suppress warnings
warning('off','images:imshow:magnificationMustBeFitForDockedFigure');
warning('off','images:initSize:adjustingMag');

%% Find Sherds
   % Grab all images under directory
filepath = strcat(image_path, '/*.', iext);

    % Collect images
files = dir(filepath);

sizes = zeros(length(files),2);

    % Run until all images cared for
for i = 1:length(files)
        % Grab next img
    impat = strcat(image_path,'/',files(i).name);
    img = imread(impat);
    
        % User feedback
    fprintf('Extracting sherd from image %i of %i\n\r',i,length(files));
    
        % Find object and crop it out
    [BW, B, edges] = cropObj(img, [tR tG tB], padding);
    
        % Show sherd process if desired
    if show > 0
        imshow(BW);                                 % Show ROI
        hold on;
        plot(B(:,2), B(:,1), 'ro-','LineWidth',2);    % Show boundary
        hold off;
        pause(show)
    else
    end
    
        % Save size of BW for later
    sizes(i,:) = size(BW);
    
        % User feedback
    sherdf = strcat(shrd_path, '/', num2str(i,'%04i'), '.', sext);
    fprintf('Saving sherd to "%s" \n\r', sherdf);
    save(sherdf,'-mat','BW','B','edges'); 
end

    % Find largest diagonal
diag = max( ceil( sqrt(sizes(:,2).^2 + sizes(:,1).^2) ) );

    % Print reccommended square dimension for SyntheticSherder.m
fprintf('Reccomended square for SyntheticSherder.m: %i\n\r', diag); 

fprintf('Saving meta.shrdinf...\n\r');
metaf = strcat(shrd_path, '/meta.shrdinf');
save(metaf,'-mat','diag'); 

fprintf('Done.\n\r');