
%[OS, Software, timestr] = FCN_ExpInitialization;
AssertOpenGL;
ListenChar(2);
bgColor = [0 0 0];
screenWidth = 1920;
screenHeight = 1080;
screenNumber=max(Screen('Screens'));
InitializeMatlabOpenGL;
%gamma=load('gamma.ilp');
try
    % set window
    [windowPtr, windowRect] = Screen('OpenWindow', screenNumber, bgColor, [0 0 screenWidth screenHeight]);

    % Key 
    myKeyCheck;
    KbName('UnifyKeyNames');
    escapeKey = KbName('ESCAPE');
    leftKey = KbName('LeftArrow');
    rightKey = KbName('RightArrow');
    
    % load stimulus meanLuminance
    load('mat/ml.mat');
    load('mat/luminance.mat');
    load('mat/ccmat.mat');
    
    % display initial text
    for i = 1:60*2
        Screen('TextSize', windowPtr, 24);
        myText = ['test'];
        DrawFormattedText(windowPtr, myText, 'center', 'center', [255 255 255]);
        Screen('Flip', windowPtr);
    end
    
    % set parameter
    [mx,my] = RectCenter(windowRect);
    px = 300;
    py = 300;
    distance = mx/2;
    scale = 1/3;
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
    
    for i = 1:9*repeat
        SetMouse(screenWidth/2,screenHeight/2);
        OneorTwo = randi([1 2]);
        % wait key input  and  judge whether correct
        while true
            [x,y,buttons] = GetMouse;
            if OneorTwo == 1
                Screen('FillRect', windowPtr, x/10, leftPosition);
                Screen('FillRect', windowPtr, ccmatrix.xyz2rgb * ml(:,displayOrder(i)) * 256, rightPosition);
            else
                Screen('FillRect', windowPtr, x/10, rightPosition);
                Screen('FillRect', windowPtr, ccmatrix.xyz2rgb * ml(:,displayOrder(i)) * 256, leftPosition);
            end
            Screen('Flip', windowPtr);
            if any(buttons)
                col = applycform([x/10 x/10 x/10] * ccmatrix.rgb2xyz / 256, C)
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