%% 明るさ測定実験
clear all

dt = char(datetime('now','Format','yyyy-MM-dd''T''HHmmss'));
sn = input('Observer initial?: ','s');
datafilename = sprintf('../data/patch/%s_%s.mat', sn, dt);

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
    HideCursor(screenNumber);

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
    Screen('TextSize', windowPtr, 35);
    myText = ['Click to start'];
    DrawFormattedText(windowPtr, myText, 'center', 'center', [255 255 255]);
    Screen('Flip', windowPtr);
    [clicks,x,y,whichButton] = GetClicks(windowPtr,0);
    Screen('Flip', windowPtr);
    WaitSecs(2);
    
    % set parameter
    [mx,my] = RectCenter(windowRect);
    px = 300;
    py = 300;
    distance = mx/1.75;
    scale = 3.5/9;
    intervalTime = 1;
    leftPosition = [mx-px*scale-distance/2, my-py*scale, mx+px*scale-distance/2, my+py*scale]; 
    rightPosition = [mx-px*scale+distance/2, my-py*scale, mx+px*scale+distance/2, my+py*scale];
    patchData = zeros(2,9);
    repeat = 5;
    C = makecform('xyz2xyl');
    
    % generate random order
    displayOrder = randperm(9*2*repeat);
    for i = 1:9*2*repeat
        displayOrder(i) = mod(displayOrder(i)-1, 18) + 1;
    end

%     d = mod(displayOrder-1,9) + 1;
%     c = ceil((displayOrder)/9);
    
    for i = 1:9*2*repeat
        SetMouse(screenWidth/2+randi(800)-200,screenHeight/2,screenNumber);
        OneorTwo = randi([1 2]);
        mcPatch = mc(:,mod(displayOrder(i)-1,9)+1,ceil(displayOrder(i)/9));
        while true
            [x,y,buttons] = GetMouse;
            if x < 300
                SetMouse(301,screenHeight/2,screenNumber);
            end
            l = (x - 300)/(screenWidth - 300) * 130;
            if OneorTwo == 1
                Screen('FillRect', windowPtr, l, leftPosition);
                Screen('FillRect', windowPtr, mcPatch, rightPosition);
            else
                Screen('FillRect', windowPtr, l, rightPosition);
                Screen('FillRect', windowPtr, mcPatch, leftPosition);
            end
            %DrawFormattedText(windowPtr, num2str(x), 'left', 'center', [255 255 255]);
            %DrawFormattedText(windowPtr, num2str(l), 'right', 'center', [255 255 255]);
            imageArray = Screen('GetImage',windowPtr);
            Screen('Flip', windowPtr);
            if any(buttons)
                col = applycform(wrgb2XYZ(ones(1,3)*l,ccmat), C);
                patchData(ceil(displayOrder(i)/9),mod(displayOrder(i)-1,9)+1) = ...
                patchData(ceil(displayOrder(i)/9),mod(displayOrder(i)-1,9)+1) + col(3);
                disp(l);
                break;
            end
            [keyIsDown, secs, keyCode, deltaSecs] = KbCheck([]);
            if keyCode(escapeKey)
                error('escape key is pressed.');
            end
        end
        for j = 1:60*intervalTime
            Screen('Flip', windowPtr);
        end     
    end
    
    patchData = patchData / repeat;
    
    finishText = 'The experiment is over.';
    DrawFormattedText(windowPtr, finishText, 'center', 'center', [255 255 255]);
    Screen('Flip', windowPtr);
    [clicks,x,y,whichButton] = GetClicks(windowPtr,0);
    
    Screen('CloseAll');
    ShowCursor;
    ListenChar(0);
    save(datafilename,'patchData')
    
%     plot(patchData(1,:),'o');
%     hold on;
%     plot(luminance(1,:));
%     hold off;

catch
    Screen('CloseAll');ls
    ShowCursor;
    a = "dame";
    ListenChar(0);
    psychrethrow(psychlasterror);
end