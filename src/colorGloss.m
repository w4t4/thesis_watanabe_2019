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
    
    % display initial text
    for i = 1:RefleshRate*5
        Screen('TextSize', windowPtr, 24);
        myText = ['choose more glossy one.'];
        DrawFormattedText(windowPtr, myText, 'center', 'center', [255 255 255]);
        Screen('Flip', windowPtr);
    end
    
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
    HideCursor(screenNumber);
    
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
                OneorTwo = randi([1 2]);
                colorLeft = combination(nckOrder(1,i,materialOrder(j)),OneorTwo);
                colorRight = combination(nckOrder(1,i,materialOrder(j)),3-OneorTwo);
                rgbLeft = stimuli(:,:,:,colorLeft,materialOrder(j));
                rgbRight = stimuli(:,:,:,colorRight,materialOrder(j));
                leftStimulus = Screen('MakeTexture', windowPtr, rgbLeft);
                rightStimulus = Screen('MakeTexture', windowPtr, rgbRight);

                for k = 1:RefleshRate*displayStimuliTime
                    Screen('DrawTexture', windowPtr, leftStimulus, [], leftPosition);
                    Screen('DrawTexture', windowPtr, rightStimulus, [], rightPosition);
                    Screen('Flip', windowPtr);
                end

                Screen('Flip', windowPtr);

                % wait click input
                whichButton = 0;
                while(whichButton ~= 1 && whichButton ~= 3)

                    [clicks,x,y,whichButton] = GetClicks(windowPtr,0);
                    disp(whichButton);
                    whichButton = whichButton(1);
                    if whichButton == 1
                        victoryTable(colorLeft,colorRight,materialOrder(j)) ...
                            = victoryTable(colorLeft,colorRight,materialOrder(j)) + 1;
                        a = "hidari";
                    elseif whichButton == 3
                        victoryTable(colorRight,colorLeft,materialOrder(j)) ...
                            = victoryTable(colorRight,colorLeft,materialOrder(j)) + 1;
                        a = "migi";
                    end
                    [keyIsDown, secs, keyCode, deltaSecs] = KbCheck([]);
                    if keyCode(escapeKey)
                        error('escape key is pressed.');
                    end
                end
                Screen('Flip', windowPtr);
                WaitSecs(intervalTime);
            end
        end
    end
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
