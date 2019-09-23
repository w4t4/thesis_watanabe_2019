

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
    load('ccmatrix.mat');
    
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
    patchData = zeros(3,9);
    C = makecform('xyz2xyl');
    
    % generate random order
    displayOrder = randperm(27);
    
    HideCursor(screenNumber);
    
    for i = 1:2
        SetMouse(screenWidth/2,screenHeight/2);
        
        % wait key input  and  judge whether correct
        while true
            [x,y,buttons] = GetMouse;
            Screen('FillRect', windowPtr, x/10, leftPosition);
            %Screen('FillRect', windowPtr, transpose(xyz2rgb(transpose(ml(:,displayOrder(i))))*16), rightPosition);
            %Screen('FillRect', windowPtr, ccmatrix.xyz2rgb * ml(:,displayOrder(i)) * 256, rightPosition);
            Screen('FillRect', windowPtr, ccmatrix.xyz2rgb * ml(:,i+7) * 256, rightPosition);
            Screen('Flip', windowPtr);
            if any(buttons)
                col = applycform([x/10 x/10 x/10] * ccmatrix.rgb2xyz / 256, C)
                %patchData(floor((displayOrder(i)-1)/9 + 1),mod(displayOrder(i),9) + 1) = col(3);
                patchData(floor((i-1)/9 + 1),mod(i,9) + 1) = col(3);
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