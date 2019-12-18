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
    PsychImaging('PrepareConfiguration')s;
    PsychImaging('AddTask', 'General', 'FloatingPoint32BitIfPossible');
    [windowPtr, windowRect] = PsychImaging('OpenWindow', screenNumber, 0);
    %[windowPtr, windowRect] = Screen('OpenWindow', screenvicNumber, bgColor, [0 0 screenWidth screenHeight]);
    Priority(MaxPriority(windowPtr));
    [offwin1,offwinrect]=Screen('OpenOffscreenWindow',windowPtr, 0);
    
    
    FlipInterval = Screen('GetFlipInterval', windowPtr); % モニタ１フレームの時間
    RefleshRate = 1./FlipInterval; % モニタ
    HideCursor(screenNumber);

    % Key 
    myKeyCheck;
    escapeKey = KbName('ESCAPE');
    leftKey = KbName('LeftArrow');
    rightKey = KbName('RightArrow');
    
    % load stimulus data
    load('../img/dragon/Dsame.mat');
    load('../img/dragon/Ddiff.mat');
    load('../img/bunny/Bsame.mat');
    load('../img/bunny/Bdiff.mat');
    load('mat/ccmat.mat');
    
    imSize = size(Dsame);
    stimuli = zeros(imSize(1),imSize(2),imSize(3),imSize(4),4);
    stimuli(:,:,:,:,1) = Dsame;
    stimuli(:,:,:,:,2) = Ddiff;
    stimuli(:,:,:,:,3) = Bsame;
    stimuli(:,:,:,:,4) = Bdiff;
    
    SetMouse(screenWidth/2,screenHeight/2,screenNumber);
    
    % display initial text
    Screen('TextSize', windowPtr, 35);
    startText = ['click to start'];
    DrawFormattedText(windowPtr, startText, 'center', 'center', [255 255 255]);
    Screen('Flip', windowPtr);
    [clicks,x,y,whichButton] = GetClicks(windowPtr,0);
    Screen('Flip', windowPtr);
    WaitSecs(2);
    
    % set parameter
    [mx,my] = RectCenter(windowRect);
    [iy,ix,iz] = size(Dsame(:,:,:,1));
    distance = mx/1.75;
    scale = 2.5/9;
    displayStimuliTime = 1;
    intervalTime = 1;
    leftPosition = [mx-ix*scale-distance/2, my-iy*scale, mx+ix*scale-distance/2, my+iy*scale]; 
    rightPosition = [mx-ix*scale+distance/2, my-iy*scale, mx+ix*scale+distance/2, my+iy*scale];
    combination = combnk(1:9,2);
    victoryTable = zeros(9,9,4);
    nckOrder = zeros(1,nchoosek(9,2),4);
    
    repetition = 4;
    
    for r = 1:repetition
        % generate random order
        for i = 1:4
            nckOrder(:,:,i) = randperm(nchoosek(9,2));
        end

        for i = 1:36
            materialOrder = randperm(4);
            %materialOrder = [1 2 3 4];
            SetMouse(screenWidth/2,screenHeight/2,screenNumber);
            for j = 1:4
                
                trialCount = 36*4*i*(r-1)+4*(i-1)+j
                if trialCount == 36*4*4/2
                    pauseText = 'click to resume';
                    DrawFormattedText(windowPtr, pauseText, 'center', 'center', [255 255 255]);
                    Screen('Flip', windowPtr);
                    [clicks,x,y,whichButton] = GetClicks(windowPtr,0);
                    Screen('Flip', windowPtr);
                    WaitSecs(2);
                end
                
                OneorTwo = randi([1 2]);
                colorLeft = combination(nckOrder(1,i,materialOrder(j)),OneorTwo);
                colorRight = combination(nckOrder(1,i,materialOrder(j)),3-OneorTwo);
                rgbLeft = stimuli(:,:,:,colorLeft,materialOrder(j));
                rgbRight = stimuli(:,:,:,colorRight,materialOrder(j));
                leftStimulus = Screen('MakeTexture', windowPtr, rgbLeft);
                rightStimulus = Screen('MakeTexture', windowPtr, rgbRight);

                [x,y,buttons] = GetMouse;
                while any(buttons)
                    [x,y,buttons] = GetMouse;
                end
                flag = 0;
                for k = 1:RefleshRate*1000
                    [x,y,buttons] = GetMouse;
                    %buttons = buttons(1)
                    if k < RefleshRate*displayStimuliTime
                        Screen('DrawTexture', windowPtr, leftStimulus, [], leftPosition);
                        Screen('DrawTexture', windowPtr, rightStimulus, [], rightPosition);
                        Screen('Flip', windowPtr);
                    else
                        Screen('Flip', windowPtr);
                    end

                    % wait click input

                    if(buttons(1) == 1 || buttons(3) == 1)

                        flag = 1;
                        if buttons(1) == 1
                            victoryTable(colorLeft,colorRight,materialOrder(j)) ...
                                = victoryTable(colorLeft,colorRight,materialOrder(j)) + 1;
                            a = "hidari";
                        elseif buttons(3) == 1
                            victoryTable(colorRight,colorLeft,materialOrder(j)) ...
                                = victoryTable(colorRight,colorLeft,materialOrder(j)) + 1;
                            a = "migi";
                        end
                        [keyIsDown, secs, keyCode, deltaSecs] = KbCheck([]);
                        if keyCode(escapeKey)
                            error('escape key is pressed.');
                        end
                    end
                    if flag == 1
                        break;
                    end
                end
                Screen('Flip', windowPtr);
                WaitSecs(intervalTime);
            end
        end
    end
    finishText = 'The experiment is over.';
    DrawFormattedText(windowPtr, finishText, 'center', 'center', [255 255 255]);
    Screen('Flip', windowPtr);
    [clicks,x,y,whichButton] = GetClicks(windowPtr,0);
    
    save(datafilename,'victoryTable');
    Screen('CloseAll');
    ShowCursor;
    ListenChar(0);

catch
    Screen('CloseAll');
    ShowCursor;
    a = "dame";
    ListenChar(0);
    psychrethrow(psychlasterror);
end
