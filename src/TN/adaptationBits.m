% adaptationBits (ver.1.5)
% 
% Present a whole screen stimulus for adaptation before experiment.
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Usage:
%     adaptationBits(window,rgb,duration,message);
% 
% Input:
%     window:   Window screen pointer
%     rgb:      Adaptation stimulus rgb(0-65535) value
%     duration: Adaptation duration (sec)
%     message:  0:no massage to the adaptation display, 
%               1:Present 'Adaptation' and 'Start' string to the adaptation display
%
% Other explanation:
%     If you want to stop stimulus presentation, press 'esc' key.
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
%     
% Created by Takehiro Nagai on 07/01/2007 (ver.1)
% 


function adaptationBits(window,rgb,duration,message)

if nargin > 4
    error('Usage: [Result Lum] = adaptationBits(window,rgb,sec,[message])');
end

if nargin==3
    message = 1;
end

[Width, Height] = Screen('Windowsize', window);

esc = KbName('esc');

backindex = 1;
stringindex = 2;

backtex = zeros(Height, Width);
backtex(:,:)=backindex-1;
backtexi = Screen('MakeTexture', window, backtex);

Clut = zeros(256,3);
Clut(backindex,:)=rgb;

% let subject know adaptation
if message
    str = 'Adaptation';
    Screen('TextFont',window, 'Arial');
    Screen('TextSize',window, 40);
    Clut(stringindex,:)=1;
    ClutEncoded = BitsPlusEncodeClutRow(Clut);
    ClutTextureIndex = Screen('MakeTexture', window, ClutEncoded);
    Screen('DrawTexture', window, backtexi, [], [0,0,Width,Height]);
    Screen('DrawText', window, str, Width.*45./100, Height.*45./100, [stringindex-1, stringindex-1, stringindex-1, 255]);
    Screen('DrawTexture', window, ClutTextureIndex, [], [0,0,524,1]);
    Screen('Flip', window);
    Screen('Close', ClutTextureIndex);
    pause(1);
end

% present adaptation stimulus
Screen('DrawTexture', window, backtexi, [], [0,0,Width,Height]);
BitsPlusSetClut(window,Clut);

% wait sec or button press
tic;
index=5;
while toc<duration
    t = toc;
    if t>index
        fprintf('%d sec\n',index);
        index = index + 5;
    end
    [res, sec, keyCode] = KbCheck;
    if keyCode(esc)
        break;
    end
end
    
% let subject know start
if message
    str = 'Start';
    Clut(stringindex,:)=1;
    ClutEncoded = BitsPlusEncodeClutRow(Clut);
    ClutTextureIndex = Screen('MakeTexture', window, ClutEncoded);
    Screen('DrawTexture', window, backtexi, [], [0,0,Width,Height]);
    Screen('DrawText', window, str, Width.*45./100, Height.*45./100, [stringindex-1, stringindex-1, stringindex-1, 255]);
    Screen('DrawTexture', window, ClutTextureIndex, [], [0,0,524,1]);
    Screen('Flip', window);
    Screen('Close', ClutTextureIndex);
    pause(1);
end

