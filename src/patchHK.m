clear all

dt = char(datetime('now','Format','yyyy-MM-dd''T''HHmmss'));
sn = input('Observer initial?: ','s');
datafilename = sprintf('../data/gloss/%s_%s.mat', sn, dt);

AssertOpenGL;
ListenChar(2);
bgColor = [0 0 0];
screenWidth = 1920;
screenHeight = 1200;
screenNumber=max(Screen('Screens'));
InitializeMatlabOpenGL;

try
    % set window
    PsychImaging('PrepareConfiguration');
    PsychImaging('AddTask', 'General', 'FloatingPoint32BitIfPossible');
    [windowPtr, windowRect] = PsychImaging('OpenWindow', screenNumber, 0);
    %[windowPtr, windowRect] = Screen('OpenWindow', screenNumber, bgColor, [0 0 screenWidth screenHeight]);
    Priority(MaxPriority(windowPtr));
    [offwin1,offwinrect]=Screen('OpenOffscreenWindow',windowPtr, 0);
    
    
    FlipInterval = Screen('GetFlipInterval', windowPtr); % モニタ１フレームの時間
    RefleshRate = 1./FlipInterval; % モニタ

    % Key 
    myKeyCheck;
    KbName('UnifyKeyNames');
    escapeKey = KbName('ESCAPE');
    leftKey = KbName('LeftArrow');
    rightKey = KbName('RightArrow');
    
    % load stimulus meanLuminance
    load('mat/mc.mat');
    load('mat/luminance.mat');
    load('mat/ccmat.mat');
    
    % display initial text
    for i = 1:60*2
        Screen('TextSize', windowPtr, 24);
        myText = ['Adjust a luminance of square to the other'];
        DrawFormattedText(windowPtr, myText, 'center', 'center', [255 255 255]);
        Screen('Flip', windowPtr);
    end
    
    % set parameter
    [mx,my] = RectCenter(windowRect);
    px = 300;
    py = 300;
    distance = mx/1.75;
    scale = 2.5/9;
    intervalTime = 1;
    leftPosition = [mx-px*scale-distance/2, my-py*scale, mx+px*scale-distance/2, my+py*scale]; 
    rightPosition = [mx-px*scale+distance/2, my-py*scale, mx+px*scale+distance/2, my+py*scale];
    patchData = zeros(1,9);
    repeat = 2;
    C = makecform('xyz2xyl');
    
    % generate random order
    displayOrder = randperm(9*repeat);
    for i = 1:9*repeat
        displayOrder(i) = mod(displayOrder(i)-1, 9) + 1;
    end
    
    HideCursor(screenNumber);
    
    %for i = 1:9*repeat
    for i = 1:1
        SetMouse(screenWidth/2,screenHeight/2,screenNumber);
        OneorTwo = randi([1 2]);
        % wait key input  and  judge whether correct
        mcPatch = wImageXYZ2rgb_wtm(mc(:,1,2),ccmat)
        while true
            [x,y,buttons] = GetMouse;
            if OneorTwo == 1
                Screen('FillRect', windowPtr, x/10, leftPosition);
                Screen('FillRect', windowPtr, mcPatch, rightPosition);
            else
                Screen('FillRect', windowPtr, x/10, rightPosition);
                Screen('FillRect', windowPtr, mcPatch, leftPosition);
            end
            Screen('Flip', windowPtr);
            if any(buttons)
                col = applycform([x/10 x/10 x/10] * ccmat.rgb2xyz / 255, C)
                patchData(1,displayOrder(i)) = patchData(1,displayOrder(i)) + col(3);
                disp(displayOrder(i));
                disp(x/10);
                break;
            end
        end
        for j = 1:60*intervalTime
            Screen('Flip', windowPtr);
        end     
    end
    
    patchData = patchData / repeat;
    
    Screen('CloseAll');
    ShowCursor;
    ListenChar(0);
    
    plot(patchData(1,:),'o');
    hold on;
    plot(luminance(1,:));
    hold off;

catch
    Screen('CloseAll');
    ShowCursor;
    a = "dame";
    ListenChar(0);
    psychrethrow(psychlasterror);
end