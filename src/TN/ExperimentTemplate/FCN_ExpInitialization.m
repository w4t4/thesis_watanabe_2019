function [OS, Software, timestr] = FCN_ExpInitialization()

% �e��ݒ�
sca; % Psychtoolbox�̂��ׂẴE�B���h�E�����iScreen Close All�j
clc; % �R�}���h�E�B���h�E���ꊇ����
more off % �R�}���h�E�B���h�E�ւ̕����\������C�ɍs��
AssertOpenGL; % OpenGL�Ɋ�Â�Screen�֐����K�؂ɓ������`�F�b�N

% �����_���ϐ�������
GetSecs;
rand('state', sum(100*clock));

% OS��
OS = OSName;

% Software
if IsOctave
    Software = 'Octave';
else
    Software = 'MATLAB';
end

% �����ϐ�
if strcmp(Software, 'MATLAB')
    t = clock; % for Mac
    timestr = sprintf('%d-%d-%d(%d-%d)', t(1),t(2),t(3),t(4),t(5)); % for Mac
elseif strcmp(Software, 'Octave')
    t = localtime(time()-9*60*60); % for Octave
    timestr = sprintf('%03d-%02d-%02d(%02d-%02d)',t.year, t.mon+1,t.mday,t.hour,t.min); %for Octave
end