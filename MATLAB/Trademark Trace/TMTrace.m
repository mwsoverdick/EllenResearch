% TMTrace.m - Trace trademarks
% Mitchell Overdick 1/15/2018

%% Initialization, non configurable
% clear all;
% close all;

%% Configurable Parameters
    % Letter of speciemen i.e. 'E' 'A' etc.
specimen    = 'G';      

img_ext     = 'jpg';        % File extension of images (no dot)

pause_t 	= 0;         	% Pause time after finishing image

%% Setup
    % Path to ceramics to be sherded (.TMT files)
image_path    = strcat('../../db/Complete Ceramics/Untraced/', specimen,'/');

    % Path to place synthetic sherds
tmt_path    = strcat('../../db/Complete Ceramics/Traced/', specimen,'/');

addpath('../lib/');

    % Make sherds path
if exist(strcat(tmt_path),'dir')~=7
    mkdir(strcat(tmt_path))
else
end

%% Main Code
    % Grab all images under directory
filepath = strcat(image_path, '/*.', img_ext);

    % Collect images
files = dir(filepath);

    % Run until all images cared for
for i = 1:length(files)
        % User feedback
    fprintf('Tracing trademark from image %i of %i\n\r',i,length(files));
    
        % Grab next img
    impat = strcat(image_path,'/',files(i).name);
    img = imread(impat);
    
        % Run drawTM
    TMBW = drawTM(img);
    
        % Save total area of TM
    TMsum = sum(sum(TMBW));
    
        % Save traced TM
    tmtf = strcat(tmt_path, files(i).name(1:end-(length(img_ext)+1)), '.TMT');
    fprintf('Saving traced TM to "%s" \n\r', tmtf);
    save(tmtf,'-mat','img','TMBW','TMsum'); 
    
        % Pause for user to observe mistakes
    pause(pause_t);   
end

fprintf('Done.\n\r');
