% udtmeasPTB3_start.m
%
% Measure intensity of a monitor using the UDT S370 photometer.
% Use to measure gamma function or check LUT tables for accuracy.
%
% Measured data is saved to "*.gamb"(ascii) and "*.row"(mat).
% Data for gamma caribration is saved to "*.lut", "*.ilut", "*ilp",
% which will be respectively used by different caribration script,
% "rgb2RGB_LUT", "rgb2RGB_iLUT", and "rgb2RGB_fitting".
%
% 4/10/03 db - correct legend on gamma plots
% 5/3/03 db  - made order of measurements for each requested level random,
%               i.e. measurements are made R,G,B,dark  R,dark,B,G  G,R,dark,B  ...
%           - added initialization of rand state with clock
% 8/19/04 db - changed plotting to single plot showing absolute intensity
%              (intensity before black subtraction)
% 9/22/04 - added option for dac voltage measurement. still needs work.
%
% 10/4/06 - simplify interface, various
% 05/25/07 - setup the script for PTB-3
% 06/29/07 - modify the script for Bits++ w/ PTB-3
% 04/21/10 - setup the script for ColorCAL

% Global variables from GUI
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

% key code
esc = KbName('esc');
space = KbName('space');
TNDisableKeysForKbCheck({'esc', 'space'});

% replace variables
gammaorcheck = MODE;
LUTmode = GAMMA_CORRECTION_METHOD;

% move to working folder
cd(WORKING_FOLDER);


% --- check gamma correction file existence ---
if gammaorcheck=='c'&& LUTmode == '1'&&fopen([INPUT_FILE_NAME '.lut']) == -1
    str = [INPUT_FILE_NAME '.lut do not exist. Please input other name.'];
    infostring = MakeInfoString(infostring,str,handles.infotext);
    return;
elseif gammaorcheck=='c'&& LUTmode == '2'&&fopen([INPUT_FILE_NAME '.ilut']) == -1
    str = [INPUT_FILE_NAME '.ilut do not exist. Please input other name.'];
    infostring = MakeInfoString(infostring,str,handles.infotext);
    return;
elseif gammaorcheck=='c'&& LUTmode == '3'&&fopen([INPUT_FILE_NAME '.ilp']) == -1
    str = [INPUT_FILE_NAME '.ilp do not exist. Please input other name.'];
    infostring = MakeInfoString(infostring,str,handles.infotext);
    return;
end
    
% --- check save file existence ---
if gammaorcheck=='g' && fopen([OUTPUT_FILE_NAME '.gamb']) ~= -1
    fclose('all');  
    str = [OUTPUT_FILE_NAME '.gamb exist. Please input other name.'];
    infostring = MakeInfoString(infostring,str,handles.infotext);
    return;
elseif gammaorcheck=='c'&&fopen([OUTPUT_FILE_NAME '.chk']) ~= -1
    fclose('all');  
    str = [OUTPUT_FILE_NAME '.chk exist. Please input other name.'];
    infostring = MakeInfoString(infostring,str,handles.infotext);
    return;
elseif gammaorcheck=='c'&&fopen([OUTPUT_FILE_NAME '.cc']) ~= -1
    fclose('all');  
    str = [OUTPUT_FILE_NAME '.cc exist. Please input other name.'];
    infostring = MakeInfoString(infostring,str,handles.infotext);
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
    keys{1} = 'esc';
    keys{2} = 'space';
    TNDisableKeysForKbCheck(keys);
    
    
    % --- Bits++ initialization (make the Bits++ receive T-Lock signal) ---
    % ResetBits;      
    infostring = MakeInfoString(infostring,'Bits++ initialization OK!',handles.infotext);   


    
    % --- monitor initialization ---
    AssertOpenGL;  % give warning if the psychotoolbox is not based on OpenGL
    screenid=max(Screen('Screens'));
    % [win, winRect] = Screen('OpenWindow', screenid, 0); 
    [win, winRect] = BitsPlusPlus('OpenWindowBits++', screenid);
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
    [win2, winRect2] = Screen('OpenWindow', 1, 255, [100 100 700 500]);
    Screen('TextFont',win2, 'Arial');
    Screen('TextSize',win2, 14); 
    Screen('Preference', 'TextAntiAliasing', 2); % anti-aliasing??
    infostring2 = cell(20,1);
    for i=1:16; infostring2{i}='empty-'; end;

    infostring2 = MakeInfoString2(win2, infostring2, 'Bits++ initialization OK!');   
 

    
    % --- Bits++ CLUT initialization ---
    Clut = [1:256; 1:256; 1:256]' * 256;	
    ClutLinear = [1:256; 1:256; 1:256]' * 256;	
    BitsPlusSetClut(win,Clut);
    
    infostring = MakeInfoString(infostring,'PTB-3 initialization OK!',handles.infotext);   
    infostring2 = MakeInfoString2(win2, infostring2, 'PTB-3 initialization OK!');
    infostring2 = MakeInfoString2(win2, infostring2, ' ');

   
    
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
    


    % --- make stimulus texture ---
    testindicies = zeros(Height, Width);
    if fullorspot=='f'
        testindicies = TARGETINDEX;
        infostring = MakeInfoString(infostring,'Using full field ...',handles.infotext);
        infostring2 = MakeInfoString2(win2, infostring2, 'Using full field ...');
    elseif fullorspot=='s'
        spot_diam = Height./4;    %radius
        blobxdif = (1:Width)-x0;
        blobydif = (1:Height)-y0;
        difsum = sqrt(repmat(blobxdif,Height,1).^2 + repmat(blobydif',1,Width).^2);
        for i=1:Height		
            for j=1:Width
                if difsum(i,j) > spot_diam
                    testindicies(i,j)=BACKINDEX; 
                else
                    testindicies(i,j)=TARGETINDEX;
                end; 
            end;
        end;
        infostring = MakeInfoString(infostring,'Using spot stimulus...',handles.infotext);
        infostring2 = MakeInfoString2(win2, infostring2, 'Using spot stimulus ...');
    end
    testindicies = testindicies - 1;    % maintain relationship between pixel value(0~255) and CLUT index(1~256)
    testtexture = Screen( 'MakeTexture', win, testindicies);

          
    
    % --- display stimulus ---
    Clut(BACKINDEX, :) = backRGB;
    Clut(TARGETINDEX, :) = spotRGB;
    ClutEncoded = BitsPlusEncodeClutRow(Clut);
    ClutTextureIndex = Screen('MakeTexture', win, ClutEncoded);
    Screen('DrawTexture', win, testtexture, [], [0,0,Width,Height]);
    Screen('LoadNormalizedGammaTable', win, Clut./65536, 2);
    % Screen('DrawTexture', win, ClutTextureIndex, [], [0,0,524,1]);
    Screen('Flip', win);


    % --- colorCAL initialization ---
    crsLoadConstants;
    global CRS;
    colorCALinit;
    infostring = MakeInfoString(infostring,'ColorCAL initialization OK!',handles.infotext);
    infostring2 = MakeInfoString2(win2, infostring2, 'ColorCAL initialization OK!');

    
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
    infostring2 = MakeInfoString2(win2, infostring2, ' ');
    infostring2 = MakeInfoString2(win2, infostring2, 'Set ColorCAL to the center spot');
    infostring2 = MakeInfoString2(win2, infostring2, 'and press the SPACE key to begin measurments...');
    while 1
        [res, sec, keyCode]=KbCheck;
        if res && keyCode(space)
            break;
        end;
    end
    infostring2 = MakeInfoString2(win2, infostring2, 'Beginning measurements ...');
    infostring2 = MakeInfoString2(win2, infostring2, 'Hold down ESC key to quit');
    infostring2 = MakeInfoString2(win2, infostring2, '-----');
    infokeystring2 = MakeInfoString2(win2, infostring2, ' ');
    infostring = MakeInfoString(infostring,'Beginning measurements ...',handles.infotext);    
    
    
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
                infostring2 = MakeInfoString2(win2, infostring2, condition);
                
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
                Clut(TARGETINDEX, :) = spotRGB;
                Clut2 = Clut./65536;
                % ClutEncoded = BitsPlusEncodeClutRow(Clut);
                % ClutTextureIndex = Screen('MakeTexture', win, ClutEncoded);
                Screen('DrawTexture', win, testtexture, [], [0,0,Width,Height]);
                tic;
                Screen('LoadNormalizedGammaTable', win, Clut2, 2);
                fprintf('%f sec\n',toc);
                % Screen('DrawTexture', win, ClutTextureIndex, [], [0,0,524,1]);
                Screen('Flip', win);
                % Screen('Close', ClutTextureIndex);
                
                % measurement
                ReadCC = colorCALread;
                result(gun, sample, n+1, :) = [x ReadCC(3)];    % luminance
                if n==nrange    % XYZ only for maximum measurement
                    Yxy = [ReadCC(3);ReadCC(1);ReadCC(2)];
                    z = 1 - Yxy(2) - Yxy(3);
                    XYZ(1,i) = Yxy(1)*Yxy(2,i)/Yxy(3,i);
                    XYZ(2,i) = Yxy(1);
                    XYZ(3,i) = Yxy(1)*z/Yxy(3,i);
                end

                
                trial = trial + 1;
                
                [res, sec, keyCode]=KbCheck;
                if res && keyCode(esc)
                    % closeUDT;
                    Screen('CloseAll');
                    % ResetBits
                    infostring = MakeInfoString(infostring,'Quit by user response.',handles.infotext); 
                    infostring = MakeInfoString(infostring,' ',handles.infotext);
                    infostring = MakeInfoString(infostring,' ',handles.infotext);
                    return;
                end
            end   % for gun
        end  % for n (level)
    end % for sample
    stoptime = clock;
    dur=datevec(datenum(stoptime)-datenum(starttime));
    str = sprintf('Measurements took %d hours and %d minutes\n', dur(4), dur(5));
    infostring = MakeInfoString(infostring, 'Measurement finished.' ,handles.infotext);
    infostring = MakeInfoString(infostring, str ,handles.infotext);
    infostring2 = MakeInfoString2(win2, infostring2, str);
    
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

    % compute correlation coefficient
    ccoef(1,:,:)=corrcoef(data(:,1),data(:,2));
    ccoef(2,:,:)=corrcoef(data(:,1),data(:,3));
    ccoef(3,:,:)=corrcoef(data(:,1),data(:,4));
    ccoefn = ccoef(:,1,2);
    
    % make ccmat data (only for enviroment without spectral measurement (eg PR-650))
    % ccmat = MakeCcmatBits(XYZ);
    

    
    % --- save data to file ---
    if gammaorcheck=='g'
        %save ofname data -ascii -tabs
        eval(['save ' ofname '.gamb' ' data -ascii -tabs'])
        str = ['"' ofname '.gamb" was created.'];
        infostring = MakeInfoString(infostring, str ,handles.infotext);
        infostring2 = MakeInfoString2(win2, infostring2, str);
        %save row data as a mat file
        eval(['save ' ofname '.row' ' result -mat'])
        str = ['"' ofname '.row" was created.'];
        infostring = MakeInfoString(infostring, str ,handles.infotext);
        infostring2 = MakeInfoString2(win2, infostring2, str);
    elseif gammaorcheck=='c'
        eval(['save ' ofname '.chk' ' data -ascii -tabs'])
        str = ['"' ofname '.chk" was created.'];
        infostring = MakeInfoString(infostring, str ,handles.infotext);
        eval(['save ' ofname '.cc' ' ccoefn -ascii -tabs'])
        str = ['"' ofname '.cc" was created.'];
        infostring = MakeInfoString(infostring, str ,handles.infotext);
    else
        save
        infostring = MakeInfoString(infostring,'something went wrong, workspace saved in matlab.mat',handles.infotext);
    end
    
   
    % --- interpolation process ---
    if gammaorcheck=='g'
        ofns = fitint2voltBits(ofname);
        infostring = MakeInfoString(infostring,' ',handles.infotext);
        infostring = MakeInfoString(infostring,ofns{1},handles.infotext);
        infostring = MakeInfoString(infostring,ofns{2},handles.infotext);
        infostring = MakeInfoString(infostring,ofns{3},handles.infotext);
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
    infostring = MakeInfoString(infostring,' ',handles.infotext);
    infostring = MakeInfoString(infostring,'Done.',handles.infotext);

    
    
catch
    errmsg = lasterr;
    
    fprintf('\n\nSome errors occured.\n');
    fprintf('------ Error message ------\n');
    fprintf('%s\n',errmsg);
    fprintf('---------------------------\n');

    % closeUDT;
    Screen('CloseAll');
    infostring = MakeInfoString(infostring,'Error!',handles.infotext);
     
    % ... rethrow the error.
    % psychrethrow(psychlasterror);
end
