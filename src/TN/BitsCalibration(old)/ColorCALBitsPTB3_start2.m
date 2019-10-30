
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




% replace variables
gammaorcheck = MODE;
LUTmode = GAMMA_CORRECTION_METHOD;

% move to working folder
eval(['cd ' WORKING_FOLDER]);

standardPCgamma = 2.2;   % Gamma for calculating approximate intensity when gamma correction is disabled.
rand('state',sum(100*clock)); % initial state of random number generator



% --- text information initialization ---
[win2, winRect2] = Screen('OpenWindow', 1, 255, [100 100 700 500],32,2);
Screen('TextFont',win2, 'Arial');
Screen('TextSize',win2, 16); 
infostring2 = cell(16,1);
for i=1:16; infostring2{i}='empty-'; end;

% --- text information initialization ---
    % --- monitor initialization ---
    screenid=max(Screen('Screens'));
    AssertOpenGL;   % give warning if the psychotoolbox is not based on OpenGL
    [win, winRect] = Screen('OpenWindow', screenid, 128);   
    % Find out the size of the lut, install a linear gamma table. This
    % happens to be quit important for bits++ too 
    [gammatable, dacbits, reallutsize] = Screen('ReadNormalizedGammaTable', win);
    % ----------------Attention!!-------------------
    % ----------------------------------------------
    % linear_gammtable=repmat(linspace(0,1,reallutsize)',1,3);   
    linear_gammtable=repmat(linspace(0,((reallutsize-1)./reallutsize),reallutsize)',1,3);
    % -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
    % Either of two lines above would be effective depending on video cards. 
    % Please comment a unnecessary line out.
    % ----------------------------------------------
    % ----------------------------------------------
    Screen('LoadNormalizedGammaTable', win, linear_gammtable);



infostring2 = MakeInfoString2(win2, infostring2, 'UDT initialization OK!');
pause(1)
infostring2 = MakeInfoString2(win2, infostring2, '444');
pause(1)

    % --- Bits++ CLUT initialization ---
    Clut = [1:256; 1:256; 1:256]' * 257;	
    ClutLinear = [1:256; 1:256; 1:256]' * 257;	
    BitsPlusSetClut(win,Clut);
    Screen('Flip',win);      

    
infostring2 = MakeInfoString2(win2, infostring2, 'I am a pen.');
infostring2 = MakeInfoString2(win2, infostring2, 'I am a pen.');
infostring2 = MakeInfoString2(win2, infostring2, 'I am a pen.');
infostring2 = MakeInfoString2(win2, infostring2, 'I am a pen.');
infostring2 = MakeInfoString2(win2, infostring2, 'Press any button.');
    while 1
        if KbCheck; break; end;
    end
infostring2 = MakeInfoString2(win2, infostring2, 'I am a pen.');
infostring2 = MakeInfoString2(win2, infostring2, 'I am a pen.');
infostring2 = MakeInfoString2(win2, infostring2, 'I am a pen.');
infostring2 = MakeInfoString2(win2, infostring2, 'I am a pen.');
infostring2 = MakeInfoString2(win2, infostring2, 'I am a pen.');
infostring2 = MakeInfoString2(win2, infostring2, 'I am a pen.');
infostring2 = MakeInfoString2(win2, infostring2, 'I am a pen.');
%KbWait;

 Screen('CloseAll');

