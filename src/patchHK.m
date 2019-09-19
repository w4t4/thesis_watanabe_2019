AssertOpenGL;
ListenChar(2);
bgColor = [0 0 0];
screenWidth = 1920;
screenHeight = 1080;
screenNumber=max(Screen('Screens'));
InitializeMatlabOpenGL;
try
    % set window
    [windowPtr, windowRect] = Screen('OpenWindow', screenNumber, bgColor, [0 0 screenWidth screenHeight]);

    % Key 
    myKeyCheck;
    escapeKey = KbName('ESCAPE');
    leftKey = KbName('LeftArrow');
    rightKey = KbName('RightArrow');
    
    % load stimulus meanLuminance
    load('ml.mat');
    load('luminance.mat');
    
    % display initial text
    for i = 1:60*2
        Screen('TextSize', windowPtr, 24);
        myText = ['test'];
        DrawFormattedText(windowPtr, myText, 'center', 'center', [255 255 255]);
        Screen('Flip', windowPtr);
    end
    
    % set parameter
    [mx,my] = RectCenter(windowRect);
    px = 200;
    py = 200;
    distance = mx/3;
    scale = 1/3;
    intervalTime = 1;
    leftPosition = [mx-px*scale-distance/2, my-py*scale, mx+px*scale-distance/2, my+py*scale]; 
    rightPosition = [mx-px*scale+distance/2, my-py*scale, mx+px*scale+distance/2, my+py*scale];
    %combination = combnk(1:9,2);
    cx2r = [0.0181365527295690,-0.00472277489810677,-0.00299881628665055;-0.00682250987579903,0.0151236917574939,0.000587260246761588;0.000470145690482612,-0.000600884921905937,0.00901996577061686];
    color = [0 0 0];
    
    % generate random order
    displayOrder = randperm(27);
    
    HideCursor(screenNumber);
    
    for i = 1:9
        SetMouse(screenWidth/2,screenHeight/2);
        
        % wait key input  and  judge whether correct
        while true
            [x,y,buttons] = GetMouse;
            Screen('FillRect', windowPtr, color+x/10, leftPosition);
            Screen('FillRect', windowPtr, transpose(xyz2rgb(transpose(ml(:,displayOrder(i))))*16), rightPosition);
            Screen('Flip', windowPtr);
            if any(buttons)
                patchData(floor((displayOrder(i)-1)/9 + 1),mod(displayOrder(i),9) + 1) = color(1) + x(1)/10;
                break;
            end
        end
        for j = 1:60*intervalTime
            Screen('Flip', windowPtr);
        end     
    end
    
    Screen('CloseAll');
    ShowCursor;
    ListenChar(0);
    
    plot(patchData(1,:),'o');
    hold on;
    plot(luminance(1,:));
    hold off;
    figure;
    plot(patchData(2,:),'o');
    hold on;
    plot(luminance(2,:));
    hold off;
    figure;
    plot(patchData(3,:),'o');
    hold on;
    plot(luminance(3,:));
    
catch
    Screen('CloseAll');
    ShowCursor;
    a = "dame";
    ListenChar(0);
    psychrethrow(psychlasterror);
end