% SyntheticSherder.m - Create synthesized ML database.
% Mitchell Overdick 11/21/2017

% clear all;  % better safe than sorry

%% User Configurable Parameters
    % Safe area of plate (as percentage of radius)
safe    = 0.3;

    % Percentage of TM in sherd considered "blank" (0 to 1)
TMthresh = .015;

    % Path to processed template sherds (.shrd files)
shrd_path   = '../../db/Template Sherds/Processed';

    % Letter of speciemen i.e. 'E' 'A' etc.
specimen    = 'B';

    % Option to delete jpg_path before each run (1-yes/0-no)
delImg = 1;

    % Normalize dimensions (make all images same, square dimension)
normDim = 0;

    % How many times to stamp sherd into ceramic (randomized)
nStamps = 20;
    
    % How many sherds to use (total stamps = nStamps*nSherds*numCeramics)
nSherds = 102;

    % Show duration, 0 for off
show = 0;

%% Setup
    % Path to ceramics to be sherded (.TMT files)
tmt_path    = strcat('../../db/Complete Ceramics/Traced/', specimen);

    % Path to place synthetic sherds
blank_path    = strcat('../../db/Synthesized Sherds/Blank/', specimen,'/');
marked_path   = strcat('../../db/Synthesized Sherds/Marked/', specimen,'/');


addpath ../lib/         % Add library path

tmtExt = 'TMT';           % Extension used for trademark traced images
sext = 'shrd';          % Extension used for sherds

    % suppress warnings
warning('off','images:imshow:magnificationMustBeFitForDockedFigure');
warning('off','images:initSize:adjustingMag');

seed = 43254;           % Rand seed

if ~exist(strcat(shrd_path,'/meta.shrdinf'),'file')
    error('Missing template sherd info: "meta.shrdinf" in template sherd directory!');
else
    load(strcat(shrd_path,'/meta.shrdinf'),'-mat');
    if normDim > 0
        fprintf('Sherd image dimensions: %i x %i\n\r',diag,diag);
    else
    end
end

%% File system setup

    % Make image paths if don't exist, delete if desired
    % Make blanks path
if exist(blank_path,'dir')~=7
    mkdir(blank_path)
else
    if delImg
        rmdir(blank_path, 's')
    else
    end
end

    % Make marked path
if exist(marked_path,'dir')~=7
    mkdir(marked_path)
else
    if delImg
        rmdir(marked_path, 's')
    else
    end
end

%% Statistical Preallocations
TMpcts = zeros(nStamps*nSherds);    % TM percentages

nblank = 0;                         % Number of blanks

%% One happy notification to user before beginning hefty algorithm
fprintf('Generating %i sherds, this may take a long time\n\r',...
    length(cfiles)*nSherds*nStamps);
fprintf('Marked sherds will be stored in: \n\r \t%s\n\r',marked_path);
fprintf('Blank sherds will be stored in: \n\r \t%s\n\r',blank_path);

%% Make Sherds
    % Find all ceramics under directory
cfiles = dir(strcat(tmt_path, '/*.', tmtExt));

    % Find all sherds under directory
sfiles = dir(strcat(shrd_path, '/*.', sext));

if nSherds > length(sfiles)
    nSherds = length(sfiles);
    fprintf('nSherds is greater than available sherd files, using max possible\n\r');
else
end

    % Remember old rand seed and set new one for repeatability
rands = rng;
rng(seed);
    
tic
first = true;
    % Run until all ceramics cared for
for i = 1:length(cfiles)

        % Grab next img
    cimpat = strcat(tmt_path,'/',cfiles(i).name);
    load(cimpat,'-mat');
    
        % Find biggest object in images
    [cB, cBW] = findBigObj(img);
     
        % Find object edges
    cEdges = boundEdges(cB);
    
        % Calculate two possible radi
    radx = (cEdges(4)-cEdges(3))/2;
    rady = (cEdges(2)-cEdges(1))/2;
    
        % Find safest of two
    rad = min([radx rady]);
    
        % Calculate center of object
    center(1,1) = cEdges(3) + radx;
    center(1,2) = cEdges(1) + rady;
    
            % Show sherd process if desired
    if show > 0
        imshow(img);
        hold on;
        plot(cB(:,2), cB(:,1), 'r','LineWidth',2);    % Show boundary
        plot(center(1,1),center(1,2),'g*');
    else
    end
    
        % Run until each sherd is stamped nStamps times
    for j = 1:nSherds    
        
            % Load sherd
        spats = strcat(shrd_path,'/',sfiles(j).name);
        sherd = load(spats,'-mat');
        
            % Stamp sherd
        for k = 1:nStamps
            
                % Generate random coordinates for stamp    
            thetas = rand(1) * (2*pi);
            r = sqrt(rand(1)) * (rad * safe);
            rcoords(1) = floor(center(1,1) + r .* cos(thetas));
            rcoords(2) = floor(center(1,2) + r .* sin(thetas));

                % Generate random angle for sherd rotation
            rangle = 360*rand(1);
            
                % Rotate sherd
            rBW = uint8(rotSherd(rangle,sherd.BW));
            
                % Translate sherd by ajusting window of ceramic
            s = size(rBW);
            TL = rcoords(2) - ceil(s(1)/2)+1; % Top left
            TR = rcoords(2) + floor(s(1)/2);  % Top right
            BL = rcoords(1) - ceil(s(2)/2)+1; % Bottom Left
            BR = rcoords(1) + floor(s(2)/2);  % Bottom Right
            
                % Only normalize image size if desired
            if normDim > 0
                    % Pre allocate canvas
                out     = uint8(zeros(diag, diag, 3));

                    % Calculate positions to store sherd to keep constant dim
                    % Row:
                pdrl    = length(TL:TR);
                pdr     = floor((diag-pdrl) / 2);
                pdre    = pdr+pdrl-1;
                    % Column:
                pdcl    = length(BL:BR);
                pdc     = floor((diag-pdcl) / 2);
                pdce    = pdc+pdcl-1;

                    % Store sherd within large canvas
                out(pdr:pdre,pdc:pdce,1) = img(TL:TR,BL:BR,1).*rBW;
                out(pdr:pdre,pdc:pdce,2) = img(TL:TR,BL:BR,2).*rBW;
                out(pdr:pdre,pdc:pdce,3) = img(TL:TR,BL:BR,3).*rBW;
            else
                    % Pre allocate canvas
                out     = uint8(zeros(length(TL:TR), length(BL:BR), 3));
                
                    % Store sherd within canvas
                out(:,:,1) = img(TL:TR,BL:BR,1).*rBW;
                out(:,:,2) = img(TL:TR,BL:BR,2).*rBW;
                out(:,:,3) = img(TL:TR,BL:BR,3).*rBW;
            end
             
            
                % Check if trademark is in image
            TMchk = TMBW(TL:TR,BL:BR).*rBW;
            
                % Calculate percentage of trademark in image
            TMpct = sum(sum(TMchk))/TMsum;
            TMpcts(j+j*i)=TMpct;
            
                % See if image qualifies as "Blank"
            if TMpct <= TMthresh
                blank = true;
            else
                blank = false;
            end
                
                % Show sherd if desired
            if show > 0
                figure(2);
                imshow(out);
                pause(show)
            else
            end
            
                % Generate sherd image name: GROUP.INDIVIDUAL.SHERD.STAMP
            sname = strcat(cfiles(i).name(1:end-(length(tmtExt)+1)), '.',...
                        sfiles(j).name(1:end-(length(sext)+1)), '.',...
                        num2str(k,'%04i'),'.',...
                        'jpg');
                    
                % Write image
            if blank
                imwrite(out, strcat(blank_path,sname), 'JPEG');
                nblank = nblank + 1;
            else
                imwrite(out, strcat(marked_path,sname), 'JPEG');
            end
        end
    end
end

    % Stats for nerds
elap = toc;

    % Restore original settings
rng(rands)

    % Compute HMSMS
hour = floor(elap/(60*60));
elap = elap - hour*60*60;
mint  = floor(elap/60);
elap = elap - mint*60;
sec  = floor(elap);
elap = elap - sec;
msec = round(elap*1000);

    % Display stats
fprintf('Generated %i sherds in %i Hours, %i Minutes, %i Seconds, %i Milliseconds\n\r',...
    length(cfiles)*nSherds*nStamps, hour, mint, sec, msec);
fprintf('%i of %i sherds blank (%3.2f%%)\n\r',...
    nblank,...
    length(cfiles)*nSherds*nStamps,...
    (nblank/(length(cfiles)*nSherds*nStamps))*100);
