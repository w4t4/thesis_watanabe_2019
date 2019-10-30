function [OS, Software, timestr] = FCN_ExpInitialization()

% 各種設定
sca; % Psychtoolboxのすべてのウィンドウを閉じる（Screen Close All）
clc; % コマンドウィンドウを一括消去
more off % コマンドウィンドウへの文字表示を一気に行う
AssertOpenGL; % OpenGLに基づきScreen関数が適切に動くかチェック

% ランダム変数初期化
GetSecs;
rand('state', sum(100*clock));

% OS名
OS = OSName;

% Software
if IsOctave
    Software = 'Octave';
else
    Software = 'MATLAB';
end

% 時刻変数
if strcmp(Software, 'MATLAB')
    t = clock; % for Mac
    timestr = sprintf('%d-%d-%d(%d-%d)', t(1),t(2),t(3),t(4),t(5)); % for Mac
elseif strcmp(Software, 'Octave')
    t = localtime(time()-9*60*60); % for Octave
    timestr = sprintf('%03d-%02d-%02d(%02d-%02d)',t.year, t.mon+1,t.mday,t.hour,t.min); %for Octave
end