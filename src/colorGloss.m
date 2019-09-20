AssertOpenGL;
ListenChar(2);
bgColor = [0 0 0];
screenWidth = 500;
screenNumber=max(Screen('Screens'));
InitializeMatlabOpenGL;
try
    % set window
    [windowPtr, windowRect] = Screen('OpenWindow', screenNumber, bgColor, [10 20 1200 700]);

    % Key 
    myKeyCheck;
    escapeKey = KbName('ESCAPE');
    leftKey = KbName('LeftArrow');
    rightKey = KbName('RightArrow');
    
    % load stimulus data
    load('../img/mag1/SDsameDragon.mat');
    load('../img/mag1/SDdifferentDragon.mat');
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
    [iy,ix,iz] = size(SDsame(:,:,:,1));
    distance = mx/3;
    scale = 1/3;
    displayStimuliTime = 1;
    intervalTime = 1;
    leftPosition = [mx-ix*scale-distance/2, my-iy*scale, mx+ix*scale-distance/2, my+iy*scale]; 
    rightPosition = [mx-ix*scale+distance/2, my-iy*scale, mx+ix*scale+distance/2, my+iy*scale];
    combination = combnk(1:9,2);
    data = zeros(36,3);
    
    % generate random order
    displayOrder = randperm(nchoosek(9,2));
    
    for i = 1:3
        OneorTwo = randi([1 2]);
        leftStimulus = Screen('MakeTexture', windowPtr, xyz2rgb(SDdifferent(:,:,:,combination(displayOrder(i),OneorTwo)))/16.*255); % ここはキャリブレーションを加味した色変換を行う
        rightStimulus = Screen('MakeTexture', windowPtr, xyz2rgb(SDdifferent(:,:,:,combination(displayOrder(i),3-OneorTwo)))/16.*255);
        for j = 1:60*displayStimuliTime
            Screen('DrawTexture', windowPtr, leftStimulus, [], leftPosition);
            Screen('DrawTexture', windowPtr, rightStimulus, [], rightPosition);
            Screen('Flip', windowPtr);
        end
            
        Screen('Flip', windowPtr);
            
        % wait key input  and  judge whether correct
        [secs, keyCode] = KbWait([],3);
        if keyCode(leftKey)
            data(combination(displayOrder(i),1)) = combination(displayOrder(i),OneorTwo);
            a = "hidari";
        elseif keyCode(rightKey)
            data(combination(displayOrder(i),1)) = combination(displayOrder(i),3-OneorTwo);
            a = "migi";
        elseif keyCode(escapeKey)
            break;
        end
        
        for j = 1:60*intervalTime
            Screen('Flip', windowPtr);
        end

        % record result
%         result(1,uint8(abs(diffBuff)/scoreInterval+1),ceil(subjectLabAxis/2)) = result(1,uint8(abs(diffBuff)/scoreInterval+1),ceil(subjectLabAxis/2)) + isCorrect;
%         result(2,uint8(abs(diffBuff)/scoreInterval+1),ceil(subjectLabAxis/2)) = result(2,uint8(abs(diffBuff)/scoreInterval+1),ceil(subjectLabAxis/2)) + 1;
%         if isCorrect ~= wasCorrect
%             turn(subjectLabAxis) = turn(subjectLabAxis) + 1;
%         end
        
        % renew wasCorrect
%         wasCorrect = isCorrect;        
%         
%         loopCount = loopCount + 1;
                
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