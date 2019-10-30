clear all

pkg load instrument-control

KbName('UnifyKeyNames')

%% initialization
global WORKING_FOLDER;
global INPUT_FILE_NAME;
global OUTPUT_FILE_NAME;
global NUMBER_OF_LEVELS;
global SAMPLES_PER_LEVEL;
global MODE;
global GAMMA_CORRECTION_METHOD;
global SHUTDOWN;
global infostring;
global TL;
global PORT_NUM;

fprintf('Select a working folder: ');fflush(1);
WORKING_FOLDER = uigetdir('~','Select a working folder');
OUTPUT_FILE_NAME = datestr(now, 30);

NUMBER_OF_LEVELS = input('How many levels?[32]: ');
if isempty(NUMBER_OF_LEVELS)
    NUMBER_OF_LEVELS=32;
end

SAMPLES_PER_LEVEL = input('How many repetitions in each level?[3]: ');
if isempty(SAMPLES_PER_LEVEL)
    SAMPLES_PER_LEVEL=3;
end

MODE = input('Gamma Calibration(g)? or Check(c)?[g]: ','s');
if isempty(MODE)
    MODE='g';
end

if MODE == 'c'
    INPUT_FILE_NAME = input('File name for saved data?', 's');
    GAMMA_CORRECTION_METHOD = input('Gamma correction method：(1) LUT、(2) iLUT, (3) fitting', 's');
else
    INPUT_FILE_NAME = [];
    GAMMA_CORRECTION_METHOD = [];
end

PORT_NUM = input('Port Number for ColorCAL?[/dev/ttyACM0]: ', 's');
if isempty(PORT_NUM)
    PORT_NUM='/dev/ttyACM0';
end

SHUTDOWN = 'n';
TL = 1;

% key code
%esc = KbName('esc'); % for win
esc = KbName('ESCAPE');
space = KbName('space');
% TNDisableKeysForKbCheck({'esc', 'space'}); % for win
TNDisableKeysForKbCheck({'ESCAPE', 'space'});

% replace variables
gammaorcheck = MODE;
LUTmode = GAMMA_CORRECTION_METHOD;

% move to working folder
cd(WORKING_FOLDER);


% --- check gamma correction file existence ---
if gammaorcheck=='c'&& LUTmode == '1'&&fopen([INPUT_FILE_NAME '.lut']) == -1
    str = [INPUT_FILE_NAME '.lut do not exist. Please input other name.'];
    % infostring = MakeInfoString(infostring,str,handles.infotext);
    sprintf('%s\n', str);
    return;
elseif gammaorcheck=='c'&& LUTmode == '2'&&fopen([INPUT_FILE_NAME '.ilut']) == -1
    str = [INPUT_FILE_NAME '.ilut do not exist. Please input other name.'];
    % infostring = MakeInfoString(infostring,str,handles.infotext);
    sprintf('%s\n', str);
    return;
elseif gammaorcheck=='c'&& LUTmode == '3'&&fopen([INPUT_FILE_NAME '.ilp']) == -1
    str = [INPUT_FILE_NAME '.ilp do not exist. Please input other name.'];
    % infostring = MakeInfoString(infostring,str,handles.infotext);
    sprintf('%s\n', str);
    return;
end
    
% --- check save file existence ---
if gammaorcheck=='g' && fopen([OUTPUT_FILE_NAME '.gamb']) ~= -1
    fclose('all');  
    str = [OUTPUT_FILE_NAME '.gamb exist. Please input other name.'];
    % infostring = MakeInfoString(infostring,str,handles.infotext);
    sprintf('%s\n', str);
    return;
elseif gammaorcheck=='c'&&fopen([OUTPUT_FILE_NAME '.chk']) ~= -1
    fclose('all');  
    str = [OUTPUT_FILE_NAME '.chk exist. Please input other name.'];
    % infostring = MakeInfoString(infostring,str,handles.infotext);
    sprintf('%s\n', str);
    return;
elseif gammaorcheck=='c'&&fopen([OUTPUT_FILE_NAME '.cc']) ~= -1
    fclose('all');  
    str = [OUTPUT_FILE_NAME '.cc exist. Please input other name.'];
    % infostring = MakeInfoString(infostring,str,handles.infotext);
    sprintf('%s\n', str);
    return;
end


disp('ColorCALBitsPTB3 - last revised 23 April 2010')
disp(' ')
disp(' ')



standardPCgamma = 2.2;   % Gamma for calculating approximate intensity when gamma correction is disabled.
rand('state',sum(100*clock)); % initial state of random number generator

try      
    % only using keys will be activated
    keys = cell(2);
    % keys{1} = 'esc';
    keys{1} = 'ESCAPE';
    keys{2} = 'space';
    TNDisableKeysForKbCheck(keys);
    
    
    % --- Bits++ initialization (make the Bits++ receive T-Lock signal) ---
    % ResetBits;      
    % infostring = MakeInfoString(infostring,'Bits++ initialization OK!',handles.infotext);   


    
    % --- monitor initialization ---
    AssertOpenGL;  % give warning if the psychotoolbox is not based on OpenGL
    screenid=max(Screen('Screens'));
    [win, winRect] = Screen('OpenWindow', screenid, 0); 
    % Find out the size of the lut, install a linear gamma table. This
    % happens to be quit important for bits++ too 
    [gammatable, dacbits, reallutsize] = Screen('ReadNormalizedGammaTable', win);
    % ----------------Attention!!-------------------
    % ----------------------------------------------
    if TL==1  % Either of these two processes below would be effective depending on video cards.
        linear_gammtable=repmat(linspace(0,1,reallutsize)',1,3);   
    else
        linear_gammtable=repmat(linspace(0,((reallutsize-1)./reallutsize),reallutsize)',1,3);
    end
    % ----------------------------------------------
    % ----------------------------------------------
    
    Screen('LoadNormalizedGammaTable', win, linear_gammtable);% old
    % Screen('LoadNormalizedGammaTable',win,linspace(0,(255/256),256)'*ones (1,3)); % new: possibility 1
    % Screen('LoadNormalizedGammaTable',win,linspace(0,1,256)'*ones(1,3)); % new: possibility 2

 
    
    % --- text information initialization ---
    % [win2, winRect2] = Screen('OpenWindow', 1, 255, [100 100 700 500]);
    % Screen('TextFont',win2, 'Arial');
    % Screen('TextSize',win2, 14); 
    % Screen('Preference', 'TextAntiAliasing', 2); % anti-aliasing??
%     infostring2 = cell(20,1);
    for i=1:16; infostring2{i}='empty-'; end;

%     infostring2 = MakeInfoString2(win2, infostring2, 'Bits++ initialization OK!');   
 

    
    % --- Bits++ CLUT initialization ---
    %Clut = [1:256; 1:256; 1:256]' * 257;	
    %ClutLinear = [1:256; 1:256; 1:256]' * 257;	
    %BitsPlusSetClut(win,Clut);
    
    % infostring = MakeInfoString(infostring,'PTB-3 initialization OK!',handles.infotext);   
%     infostring2 = MakeInfoString2(win2, infostring2, 'PTB-3 initialization OK!');
%     infostring2 = MakeInfoString2(win2, infostring2, ' ');

    fprintf('PTB-3 initialization OK!\n');fflush(1);

   
    
    % --- load data for gamma correction ---
    if gammaorcheck=='c'    
        if LUTmode=='3';       para=load([INPUT_FILE_NAME '.ilp'],'-ascii');
        elseif LUTmode=='2';   iLUT=load([INPUT_FILE_NAME '.ilut'],'-ascii');
        elseif LUTmode=='1';   LUT=load([INPUT_FILE_NAME '.lut'],'-ascii');  
        end
    end

    
    % --- variable setting ---
    % spatial and color parameters
    Width=winRect(3);
    Height=winRect(4);
    x0=round(Width./2);
    y0=round(Height./2);
    ColorResolution=reallutsize;
    fullorspot = 's';
    
    % index number (msut be 1~256)
    BACKINDEX = 1;
    TARGETINDEX = 2;
    
    % default color
    if gammaorcheck == 'g'
        medium = round(ColorResolution .* 257 .* 0.5.^(1./standardPCgamma)); %including nonlinear gamma
        backRGB = [medium medium medium];
        spotRGB = [round(medium.*0.8) round(medium.*0.8) round(medium.*0.8)];
    elseif gammaorcheck == 'c'
        if LUTmode == '1';    
            backRGB = rgb2RGB_LUT([0.5 0.5 0.5],LUT);
            spotRGB = rgb2RGB_LUT([0.4 0.4 0.4],LUT);
        elseif LUTmode == '2';  
            backRGB = rgb2RGB_iLUT([0.5 0.5 0.5],iLUT);
            spotRGB = rgb2RGB_iLUT([0.4 0.4 0.4],iLUT);
        elseif LUTmode == '3';
            backRGB = rgb2RGB_fitting([0.5 0.5 0.5],para);
            spotRGB = rgb2RGB_fitting([0.4 0.4 0.4],para);
        end
    end
    
    % psychtoolbox用（色を0〜255に）
    backRGB = round(backRGB./257);
    spotRGB = round(spotRGB./257);

    % --- make stimulus texture ---
%     testindicies = zeros(Height, Width);
%     if fullorspot=='f'
%         testindicies = TARGETINDEX;
%         fprintf('Using full field ...');fflush(1);
%         % infostring = MakeInfoString(infostring,'Using full field ...',handles.infotext);
% %         infostring2 = MakeInfoString2(win2, infostring2, 'Using full field ...');
%     elseif fullorspot=='s'
%         spot_diam = Height./4;    %radius
%         blobxdif = (1:Width)-x0;
%         blobydif = (1:Height)-y0;
%         difsum = sqrt(repmat(blobxdif,Height,1).^2 + repmat(blobydif',1,Width).^2);
%         for i=1:Height		
%             for j=1:Width
%                 if difsum(i,j) > spot_diam
%                     testindicies(i,j)=BACKINDEX; 
%                 else
%                     testindicies(i,j)=TARGETINDEX;
%                 end; 
%             end;
%         end;
%         fprintf('Using spot stimulus...');fflush(1);
%         % infostring = MakeInfoString(infostring,'Using spot stimulus...',handles.infotext);
% %         infostring2 = MakeInfoString2(win2, infostring2, 'Using spot stimulus ...');
%     end
%     testindicies = testindicies - 1;    % maintain relationship between pixel value(0~255) and CLUT index(1~256)
%     testtexture = Screen( 'MakeTexture', win, testindicies);
    
    spot_diam = Height./4;    %radius
    blobxdif = (1:Width)-x0;
    blobydif = (1:Height)-y0;    
    difsum = sqrt(repmat(blobxdif,Height,1).^2 + repmat(blobydif',1,Width).^2);
    testindicies = difsum <= spot_diam;
    testindicies_v = reshape(testindicies, Height.*Width, 1);

          
    
    % --- display stimulus ---
    currenttex = repmat(backRGB, [Height*Width 1]);
    currenttex(testindicies_v, 1) = spotRGB(1);
    currenttex(testindicies_v, 2) = spotRGB(2);
    currenttex(testindicies_v, 3) = spotRGB(3);
    currenttex = reshape(currenttex, [Height, Width, 3]);
    
    StiTextureIndex = Screen('MakeTexture', win, currenttex);
    Screen('DrawTexture', win, StiTextureIndex, [], [0,0,Width,Height]);
    Screen('Flip', win);
    Screen('Close', StiTextureIndex);


    % --- colorCAL initialization ---
    ColorCALIICDCPort = PORT_NUM; % port number of colorCAL
    
    % calibration 1: dark adapt
    fprintf('Cover ColorCAL II, then press space key\n');fflush(1);
    [res, sec, keyCode]=KbCheck;
    while 1
        [res, sec, keyCode]=KbCheck;
        if res && keyCode(space)
            break;
        end;
    end
    ColorCALIIZeroCalibrate_linux(ColorCALIICDCPort); % calibration
    fprintf('ColorCAL initialization OK!\n');fflush(1);
    % infostring = MakeInfoString(infostring,'ColorCAL initialization OK!',handles.infotext);
%     infostring2 = MakeInfoString2(win2, infostring2, 'ColorCAL initialization OK!');

    % calibration 2: monitor adapt
    fprintf('Position ColorCAL II where desired, then press space key\n');fflush(1);
    % infostring = MakeInfoString(infostring,'Position ColorCAL II where desired, then press space key',handles.infotext);
%     infostring2 = MakeInfoString2(win2, infostring2, 'Position ColorCAL II where desired');
    [res, sec, keyCode]=KbCheck;
    while 1
        [res, sec, keyCode]=KbCheck;
        if res && keyCode(space)
            break;
        end;
    end
    myCorrectionMatrix = getColorCALIICorrectionMatrix_linux(ColorCALIICDCPort);
    fprintf('ColorCAL correction OK!\n');fflush(1);
    % infostring = MakeInfoString(infostring,'ColorCAL correction OK!',handles.infotext);
%     infostring2 = MakeInfoString2(win2, infostring2, 'ColorCAL correction OK!');
    
    
    % --- ask calibration conditions ---
    shutdn = SHUTDOWN;
    numPoints = NUMBER_OF_LEVELS;
    numSamples = SAMPLES_PER_LEVEL;
    WhichGuns = 'a';
    startval =  0;
    endval = 65535;
    Order = 'r';


    % ---- file name to save ----
    ofname = OUTPUT_FILE_NAME;

    
    % --- measuring order setting ---
    switch Order
        case 'h'
            nrange = 'numPoints-1:-1:0';
        case 'l'
            nrange = '0:numPoints-1';
        case 'r'
            nrange = 'randperm(numPoints)-1';
    end
    switch WhichGuns
        case 'r'
            grange = '[1 4]'; NumberOfGuns = 2;
            xgun = 1;
        case 'g'
            grange = '[2 4]'; NumberOfGuns = 2;
            xgun = 2;
        case 'b'
            grange = '[3 4]'; NumberOfGuns = 2;
            xgun = 3;
        case 'a'
            grange = 'randperm(4)'; NumberOfGuns = 4;
            xgun = 1;
    end


    % --- ready? ---
%     infostring2 = MakeInfoString2(win2, infostring2, ' ');
%     infostring2 = MakeInfoString2(win2, infostring2, 'Set ColorCAL to the center spot');
%     infostring2 = MakeInfoString2(win2, infostring2, 'and press the SPACE key to begin measurments...');
    
    fprintf('Set ColorCAL to the center spot, and press the space bar\n');fflush(1);
    while 1
        [res, sec, keyCode]=KbCheck;
        if res && keyCode(space)
            break;
        end;
    end
%     infostring2 = MakeInfoString2(win2, infostring2, 'Beginning measurements ...');
%     infostring2 = MakeInfoString2(win2, infostring2, 'Hold down ESC key to quit');
%     infostring2 = MakeInfoString2(win2, infostring2, '-----');
%     infokeystring2 = MakeInfoString2(win2, infostring2, ' ');
    

    % infostring = MakeInfoString(infostring,'Beginning measurements ...',handles.infotext);    
    
    
    % --- make measurements ---
    starttime = clock;
    StepSize = (endval-startval)./(numPoints-1);
    result = zeros(4, numSamples, numPoints-1, 2);
    numMeasure = numSamples .* numPoints .* NumberOfGuns;
    trial = 1;
    XYZ = zeros(4,3,numSamples);
    
    for sample = 1:numSamples
        for n=eval(nrange)
            for gun = eval(grange)
                
                % show present condition to main monitor
                condition = sprintf('- %d/%d (sample = %d, level = %d, gun = %d)',trial,numMeasure,sample,n,gun);
                fprintf('%s\n', condition);fflush(1);
                % infostring2 = MakeInfoString2(win2, infostring2, condition);
                
                % rgb determination
                spotRGB(:) = 0;
                x = round(n .* StepSize + startval - 1e-12);
                switch gun
                    case 1			% red
                        spotRGB(1) = x;
                    case 2			% green
                        spotRGB(2) = x;
                    case 3			% blue
                        spotRGB(3) = x;
                    case 4			% dark
                        x=0;
                end   % switch
                
                if gammaorcheck == 'c'
                    normspotRGB=spotRGB./65535;
                    if LUTmode == '1';    
                            spotRGB = rgb2RGB_LUT(normspotRGB,LUT);
                    elseif LUTmode == '2';
                            spotRGB = rgb2RGB_iLUT(normspotRGB,iLUT);
                    elseif LUTmode == '3';
                            spotRGB = rgb2RGB_fitting(normspotRGB,para);
                    end
                end
                
                % stimulus presentation
                spotRGB = round(spotRGB./257);
                
                currenttex = repmat(backRGB, [Height*Width 1]);
                currenttex(testindicies_v, 1) = spotRGB(1);
                currenttex(testindicies_v, 2) = spotRGB(2);
                currenttex(testindicies_v, 3) = spotRGB(3);
                currenttex = reshape(currenttex, [Height, Width, 3]);
    
                StiTextureIndex = Screen('MakeTexture', win, currenttex);
                Screen('DrawTexture', win, StiTextureIndex, [], [0,0,Width,Height]);
                Screen('Flip', win);
                Screen('Close', StiTextureIndex);
                
                % measurement
                myRecording = ColorCALIIGetValues_linux(ColorCALIICDCPort);
                cXYZ = myCorrectionMatrix * myRecording';
                result(gun, sample, n+1, :) = [x cXYZ(2)];    % luminance
                if n+1==numPoints
                    XYZ(gun, :, sample) = cXYZ; % XYZ
                end
                
                % omit saving XYZ data                
                trial = trial + 1;
                
                [res, sec, keyCode]=KbCheck;
                if res && keyCode(esc)
                    % closeUDT;
                    Screen('CloseAll');
                    % ResetBits
                    fprintf('Quit by user response.');fflush(1);
                    %infostring = MakeInfoString(infostring,'Quit by user response.',handles.infotext); 
                    %infostring = MakeInfoString(infostring,' ',handles.infotext);
                    %infostring = MakeInfoString(infostring,' ',handles.infotext);
                    return;
                end
            end   % for gun
        end  % for n (level)
    end % for sample
    stoptime = clock;
    dur=datevec(datenum(stoptime)-datenum(starttime));
    str = sprintf('Measurements took %d hours and %d minutes\n', dur(4), dur(5));
    fprintf('%s\n', str);fflush(1);
    
    %infostring = MakeInfoString(infostring, 'Measurement finished.' ,handles.infotext);
    %infostring = MakeInfoString(infostring, str ,handles.infotext);
    % infostring2 = MakeInfoString2(win2, infostring2, str);
    
    % ---------------------
    % result indices:(gun, intensity level index, repetition index, [dac value, measured intensity])
    % ---------------------
    
    
    % --- deta conversion ---
    % subtract dark measurement
    result_d = result(1:3,:,:,:);
    for gun=1:3, result_d(gun,:,:,2) = result(gun,:,:,2) - result(4,:,:,2); end
        
    % data for save
    data = [squeeze(result(xgun,1,:,1)) squeeze(mean(result(1:3,:,:,2),2))']; % don't use result_d
    %data = [squeeze(result_d(xgun,1,:,1)) squeeze(mean(result_d(:,:,:,2),2))'];

    if gammaorcheck=='c'
    % compute correlation coefficient
       ccoef(1,:,:)=corrcoef(data(:,1),data(:,2));
       ccoef(2,:,:)=corrcoef(data(:,1),data(:,3));
       ccoef(3,:,:)=corrcoef(data(:,1),data(:,4));
       ccoefn = ccoef(:,1,2);
    end
    
    % make ccmat data (only for enviroment without spectral measurement (eg PR-650))
    ccmat = MakeCcmatBits(XYZ);
    

    
    % --- save data to file ---
    if gammaorcheck=='g'
        %save ofname data -ascii -tabs
        eval(['save ' ofname '.gamb' ' data -ascii -tabs'])
        str = ['"' ofname '.gamb" was created.'];
        fprintf('%s\n', str);fflush(1);
        % infostring = MakeInfoString(infostring, str ,handles.infotext);
        % infostring2 = MakeInfoString2(win2, infostring2, str);
        %save row data as a mat file
        eval(['save ' ofname '.row' ' result -mat'])
        str = ['"' ofname '.row" was created.'];
        fprintf('%s\n', str);fflush(1);
        eval(['save ccmat' ofname '.mat' ' ccmat -mat'])
        str = ['"ccmat' ofname '.mat" was created.'];
        fprintf('%s\n');fflush(1);
        % infostring = MakeInfoString(infostring, str ,handles.infotext);
        % infostring2 = MakeInfoString2(win2, infostring2, str);
    elseif gammaorcheck=='c'
        eval(['save ' ofname '.chk' ' data -ascii -tabs'])
        str = ['"' ofname '.chk" was created.'];
        fprintf('%s\n', str);fflush(1);
        %infostring = MakeInfoString(infostring, str ,handles.infotext);
        eval(['save ' ofname '.cc' ' ccoefn -ascii -tabs'])
        str = ['"' ofname '.cc" was created.'];
        fprintf('%s\n', str);fflush(1);
        %infostring = MakeInfoString(infostring, str ,handles.infotext);
    else
        save
        fprintf('something went wrong, workspace saved in matlab.mat\n');fflush(1);
        % infostring = MakeInfoString(infostring,'something went wrong, workspace saved in matlab.mat',handles.infotext);
    end
    
   
    % --- interpolation process ---
    if gammaorcheck=='g'
        ofns = fitint2voltBits_linux(ofname);
        %infostring = MakeInfoString(infostring,' ',handles.infotext);
        %infostring = MakeInfoString(infostring,ofns{1},handles.infotext);
        %infostring = MakeInfoString(infostring,ofns{2},handles.infotext);
        %infostring = MakeInfoString(infostring,ofns{3},handles.infotext);
    end
    
    
    % --- create a graph for chack mode---
    if gammaorcheck=='c'
        figure;
        hold on;
        plot(data(:,1),data(:,2),'r',data(:,1),data(:,2),'ro');
        plot(data(:,1),data(:,3),'g',data(:,1),data(:,3),'go');
        plot(data(:,1),data(:,4),'b',data(:,1),data(:,4),'bo');
        xlabel('DAC of Bits++');
        ylabel('Normalized intensity')
        hold off;        
    end
    
       
    % --- Done. Close Screen, release all ressouces: ---
    Screen('CloseAll');
    clear mex
    
    
    % --- Initialize Bits++ ---
    % ResetBits;
    
    
    
    % --- PC shutdown ---
    if shutdn=='y'
        !shutdown -s -f
        exit
    end
    
    
    % --- finish! ---
    %infostring = MakeInfoString(infostring,' ',handles.infotext);
    %infostring = MakeInfoString(infostring,'Done.',handles.infotext);
    fprintf('Done!\n');fflush(1);
    
    
catch
    errmsg = lasterr;
    
    fprintf('\n\nSome errors occured.\n');fflush(1);
    fprintf('------ Error message ------\n');fflush(1);
    fprintf('%s\n',errmsg);fflush(1);
    fprintf('---------------------------\n');fflush(1);

    % closeUDT;
    Screen('CloseAll');
    % infostring = MakeInfoString(infostring,'Error!',handles.infotext);
     
    % ... rethrow the error.
    % psychrethrow(psychlasterror);
end
