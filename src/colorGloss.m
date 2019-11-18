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
    load('../img/sphere/Ssame.mat');
    load('../img/sphere/Sdiff.mat');
    load('mat/ccmat.mat');
    
    imSize = size(Dsame);
    stimuli = zeros(imSize(1),imSize(2),imSize(3),imSize(4),6);
    stimuli(:,:,:,:,1) = Dsame;
    stimuli(:,:,:,:,2) = Ddiff;
    stimuli(:,:,:,:,3) = Bsame;
    stimuli(:,:,:,:,4) = Bdiff;
    stimuli(:,:,:,:,5) = Ssame;
    stimuli(:,:,:,:,6) = Sdiff;
    
    
    % display initial text
    for i = 1:60*2
        Screen('TextSize', windowPtr, 24);
        myText = ['choose more glossy one.'];
        DrawFormattedText(windowPtr, myText, 'center', 'center', [255 255 255]);
        Screen('Flip', windowPtr);
    end
    
    % set parameter
    [mx,my] = RectCenter(windowRect);
    [iy,ix,iz] = size(Dsame(:,:,:,1));
    distance = mx/2;
    scale = 2/9;
    displayStimuliTime = 1;
    intervalTime = 1;
    leftPosition = [mx-ix*scale-distance/2, my-iy*scale, mx+ix*scale-distance/2, my+iy*scale]; 
    rightPosition = [mx-ix*scale+distance/2, my-iy*scale, mx+ix*scale+distance/2, my+iy*scale];
    combination = combnk(1:9,2);
    victoryTable = zeros(9,9,6);
    nckOrder = zeros(1,nchoosek(9,2),6);
    
    % generate random order
    for i = 1:6
        nckOrder(:,:,i) = randperm(nchoosek(9,2));
    end
    HideCursor(screenNumber);
    
    for i = 1:1
        
        materialOrder = randperm(6);
        for j = 1:6
            OneorTwo = randi([1 2]);
            rgbLeft = stimuli(:,:,:,combination(nckOrder(i,j),OneorTwo),materialOrder(j));
            rgbRight = stimuli(:,:,:,combination(nckOrder(i,j),3-OneorTwo),materialOrder(j));
            %rgbLeft = Dsame(:,:,:,i);
            %rgbRight = Ddiff(:,:,:,i);
            leftStimulus = Screen('MakeTexture', windowPtr, rgbLeft);
            rightStimulus = Screen('MakeTexture', windowPtr, rgbRight);

            for k = 1:60*displayStimuliTime

                Screen('DrawTexture', windowPtr, leftStimulus, [], leftPosition);
                Screen('DrawTexture', windowPtr, rightStimulus, [], rightPosition);
                Screen('Flip', windowPtr);

            end

            Screen('Flip', windowPtr);

            % wait key input
            [secs, keyCode] = KbWait([],3);
            if keyCode(leftKey)
                %data(combination(displayOrder(i),1)) = combination(displayOrder(i),OneorTwo);
                a = "hidari";
            elseif keyCode(rightKey)
                %data(combination(displayOrder(i),1)) = combination(displayOrder(i),3-OneorTwo);
                a = "migi";
            elseif keyCode(escapeKey)
                break;
            end        

            for k = 1:60*intervalTime
                Screen('Flip', windowPtr);
            end     
        end
    end
    
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