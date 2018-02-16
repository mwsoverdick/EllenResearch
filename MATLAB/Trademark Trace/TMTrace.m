% TMTrace.m - Trace trademarks
% Mitchell Overdick 1/15/2018

%% Initialization, non configurable
clear all;
close all;

%% Configurable Parameters
    % Path to folder with untraced ceramic images
image_path	= '../../db/Complete Ceramics/Untraced/G';          

    % Path to write TMT files to
tmt_path    = '../../db/Complete Ceramics/Traced/G';    

img_ext     = 'jpg';        % File extension of images (no dot)

pause_t 	= 1.5;         	% Pause time after finishing image

%% Setup
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
    tmtf = strcat(tmt_path, '/', files(i).name(1:end-(length(img_ext)+1)), '.TMT');
    fprintf('Saving traced TM to "%s" \n\r', tmtf);
    save(tmtf,'-mat','img','TMBW','TMsum'); 
    
        % Pause for user to observe mistakes
    pause(pause_t);   
end

fprintf('Done.\n\r');
