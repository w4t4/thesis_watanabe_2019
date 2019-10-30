

% Screen('Preference', 'SkipSyncTests', 1); % �G���[���b�Z�[�W�ł�����ĂԂ悤����ꂽ��A�R�����g���O��

clear all % ���[�N�X�y�[�X���̕ϐ�������
[OS, Software, timestr] = FCN_ExpInitialization; % OS: OS���ASoftware: MATLAB/Octave�Atimestr: ���݂̎����̕�����

load('ccmat.mat'); % 'ccmat'�Ƃ����ϐ����ł���
gamma=load('gamma.ilp');  % gamma.lut�Agamma.ilut���B�F�ϊ��v�Z�ߒ����Ⴄ�B�ڍׂ͕ʓr�B


%***************************************
%       -- Initialization --
% ______________________________________

% �L�[�{�[�h�ݒ�F�g�������L�[�̖��O�������Őݒ�B�e�L�[�̖��̂�KbName�֐��Œ��ׂ���B
KbName('UnifyKeyNames'); % OS�Ԃ̃L�[�̖��̂̈Ⴂ���Ȃ���
    % �ȉ��A��Ƃ��āAESC�A����A�����̐ݒ�̗������
    escape = KbName('Escape');
    upkey = KbName('UpArrow');
    leftkey = KbName('LeftArrow');

sn = input('Observer initial?: ','s');
    
datafilename = sprintf('%s_%s_%s.mat', mfilename, sn, timestr); 

bgrgb = [1,1,1];

adaptsec = 60; % �����h���P��������̒掦���ԁis�j
% �ȉ��͂����܂ŗ�B�h���T�C�Y�����߂Ă���B�ȉ��̗l�ȏ�񂪂Ȃ��ƃR���s���[�^��ł̎h���T�C�Y�i�s�N�Z�����j���v�Z�ł��Ȃ�
ViewingDistance = 57; % ������(cm)
ScreenWidthCM = 36; % �X�N���[���̉����icm�j
radiusDeg = 6; % �~�`�h���̔��a�i���pdegree�j�B

try
    PsychImaging('PrepareConfiguration');
    screenid = max(Screen('Screens'));
    PsychImaging('AddTask', 'General', 'FloatingPoint32BitIfPossible'); % �n�[�h�E�F�A�̐��\�������ꍇ�A�A���t�@�u�����f�B���O�̐��x���グ��
    % Bits#��Color++���[�h�Ŏg�������ꍇ�A�ȉ��̃R�����g���O��
    %   PsychImaging('AddTask', 'General', 'EnableBits++Color++Output',2);
    % Bits#��Bits++���[�h�Ŏg�������ꍇ�A�ȉ��̃R�����g���O��
    %   PsychImaging('AddTask', 'General', 'EnableBits++Bits++Output');
    [win, winRect] = PsychImaging('OpenWindow', screenid, 0); % ��L��AddTask�̐ݒ�ɉ�����Window���I�[�v������
    Priority(MaxPriority(win)); % OS��Screen�ɑ΂���^�X�N�D��x���ő�ɂ��A�`�惊�A���^�C�������グ��
    [offwin1,offwinrect]=Screen('OpenOffscreenWindow',win, 0); % ����Offwin1�ϐ��̓I�t�X�N���[���ŁADrawOval�֐��ȂǂŒ��ڕ`��ł��郁���b�g����B�g���l�͎g���͂��B
    
    [winwidth, winheight]=Screen('WindowSize', win); % �X�N���[���̃s�N�Z���T�C�Y 
    [cx,cy]=RectCenter(winRect); % �X�N���[���̒������W
    FlipInterval = Screen('GetFlipInterval', win); % ���j�^�P�t���[���̎���
    RefleshRate = 1./FlipInterval; % ���j�^
   
    
    %***************************************************
    % �@�@�@�@-- Sound setup --
    % Psychtoolbox�̉��̃Z�b�g�A�b�v�B
    % __________________________________________________ 
    % ���̍쐬�B�����܂ň��BMakeBeep�֐����g�킸wav�t�@�C������ǂݍ��ނ��Ƃ���(psychwavread�֐����g���Ɨǂ�)�B
        % �p�����[�^
        sr = 44100; % �T���v�����O���[�g
        beeptime = 0.1; % �b
        freq = 1000; % Hz
    mybeep = 0.5 * MakeBeep(freq, beeptime, sr); % ���̔g�`���ł���
    mybeep = repmat(mybeep, [2, 1]);
    
    % Psychtoolbox�̉��ݒ�̏�����
    InitializePsychSound(1);
    ps.pahandle = PsychPortAudio('Open');
    ps.mybeep = mybeep;
    PsychPortAudio('FillBuffer', ps.pahandle, ps.mybeep); % �����T�E���h�o�b�t�@�[�Ɋi�[�i�܂���Ȃ��j
    startTime = PsychPortAudio('Start', ps.pahandle); % ����炷�B���炵�Ă����Ǝ���͎��Ԓx�ꂪ�Ȃ�������
    
    
    %***************************************************
    % �@�@�@�@-- Other setups --
    % ����Psychtoolbox�֘A�ŃZ�b�g�A�b�v���K�v�Ȃ炱���ɁB
    % __________________________________________________     
    % �}�E�X�J�[�\�����B��:
    HideCursor(screenid);
    
        
    %***************************************************
    %           -- �����ŏI���� --
    % __________________________________________________         

    % �ȉ��͈��B�팱�҂��N���b�N����Ǝ������n�܂�悤�ɂ���
    % Text for observer ready
    mytext = 'Click to start experiment';
    Screen('TextSize', win, 50);
    Screen('FillRect', win, [0 0 0]); % �X�N���[���������h��
    DrawFormattedText(win, mytext, 'center', 'center',[255 255 255]); % �����`��
    ts = Screen('Flip',win);  % ���ۂɕ`��
    
    % Wait for observer's click
    [clicks,x,y,whichButton] =GetClicks;
    
    %***************************************************
    %           -- �w�i���� --
    % �����̎����ŁA�����O�ɔw�i��m�C�Y���ɏ��������邱�ƂɂȂ�B
    % �����ɂ́A������L�q����B
    % __________________________________________________       
    
    
    %***************************************************
    %               -- �����葱�� --
    % �����̖{�́B�h���掦�A�팱�҉����A���ʋL�^�̌J��Ԃ��ȂǁB
    % �㉺�@���g���Ȃ�ATN toolbox�́uNormalStair�v���g���Ƒ������N�B
    % __________________________________________________      
    
    %%%%% for�܂���while���[�v�Ŏ��s���J��Ԃ� %%%%%%%%%%%%%%%%%%%%
    
    
    %%%%% �F�̌v�Z��h���̏��� %%%%%%%%%%%%%%%%%%%%
        % �e���s���s�����������K���t�@�C���ɕۑ����Ȃ���΂Ȃ�Ȃ��̂ŁA���s�̓����擾�B
    if strcmp(Software, 'MATLAB')
        t = clock; % for Mac
        timestr = sprintf('%d-%d-%d(%d-%d)', t(1),t(2),t(3),t(4),t(5)); % for Mac
    elseif strcmp(Software, 'Octave')
        t = localtime(time()-9*60*60); % for Octave
        timestr = sprintf('%03d-%02d-%02d(%02d-%02d)',t.year, t.mon+1,t.mday,t.hour,t.min); %for Octave
    end
    
    
    %%%%% �h���̒掦 %%%%%%%%%%%%%%%%%%%%
    
    % for Bits# Bits++���[�h���[�U�[
    % LUT��'clut'�Ƃ����ϐ��ɒu�����Ƃ���ƁA
    %   Screen('LoadNormalizedGammaTable', windowPtr, baseclut, 2);
    % �Ə���������LUT��Bits#�ɔ��f�����iT-Lock�R�[�h�������I�ɃX�N���[���ɕ`�悳���j
    
    % for BIts# Colour++���[�h���[�U�[
    % �ʏ�ʂ胂�j�^��0<rgb<1�͈̔͂ŕ`�悷�邱�ƂŁA���E�s�N�Z�������ω�����A14bit��RGB�ŕ\�������B
    % �����I�ɗ׍����s�N�Z�������ω�����Ă��܂����Ƃɒ��ӁB
    
    %%%%% �팱�҉����̎擾 %%%%%%%%%%%%%%%%%%%%
    % �ȉ��͈��B�}�E�X�ƃL�[�{�[�h�ŉ��������
        % �팱�҂��}�E�X�{�^������x�����Ă��邱�Ƃ��m�F�B
    [x,y,buttons] = GetMouse;
    while any(buttons) 
        [x,y,buttons] = GetMouse;
    end
    
        % �팱�҉���
    keyIsDown = 0;
    while ~any(buttons) && ~keyIsDown % �}�E�X���L�[�{�[�h���������܂Ń��[�v
        SetMouse(500,500); % �}�E�X�̈ʒu���Œ肷��
        [x,y,buttons] = GetMouse; % �}�E�X�����̎擾�ibuttons�ϐ��j
        [ keyIsDown, seconds, keyCode ] = KbCheck(-1); % �L�[�{�[�h�������擾�ikeyCode�ϐ��j�F -1 means checking all keyboards
        if keyIsDown && keyCode(escape) % ESC�L�[�������ꂽ��t���O�𗧂Ă�i������r���ŏI����ꍇ�ȂǂɎg����j
            flag = 1;
            break;
        end
    end    
        
    
    %%%%% �팱�҉����̔��f�i���딻��Ȃǁj %%%%%%%%%%%%%%%%%%%%
    
        startTime = PsychPortAudio('Start', ps.pahandle ); % �팱�҂ɉ��Ńt�B�[�h�o�b�N���o�����肷��
    
    %%%%% �������ʂ̕ϐ��ւ̊i�[�A�t�@�C���ւ̋L�^�B�ł���Ζ����s�i�[����B %%%%%%%%%%%%%%%%%%%%
    
    %%%%% ���[�v�̏����A����i�������I���Ȃ̂��A���̏����ɍs���̂��j %%%%%%%%%%%%%%%%%%%%
    
    
    
    %***************************************************
    %                 -- Clean up --
    % 
    % __________________________________________________    

    FCN_ExpFinalization(screenid); % Psychtoolbox�̂��ЂÂ�
    
%***************************************************
%     -- In case any errors occurs... --
% __________________________________________________       
catch
    FCN_ExpFinalization(screenid);

    psychrethrow(psychlasterror); % �G���[�̕\��
end