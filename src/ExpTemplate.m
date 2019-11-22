%%%%%%%%%%%%%%%%%%%%
%  ExpTemplate.m
%%%%%%%%%%%%%%%%%%%%
% 
% 永井研心理物理実験用MATLAB/Octave template.
% 
% 心理物理実験で通常行われる手続きをすべて含んでいるので
% これをベースに各自の実験を行うと良い。
% 同一フォルダにある他のサブ関数とともに使用すると良い。
% 
%
% Created by Takehiro Nagai on April 4, 2016.
%%%%%%%%%%%%%%%%%%%%

% Screen('Preference', 'SkipSyncTests', 1); % エラーメッセージでこれを呼ぶよう言われたら、コメントを外す

%***************************************
%       -- 実験初期化 --
% ワークスペース消去、more off、etc...
% ______________________________________
clear all % ワークスペース内の変数を消去
%[OS, Software, timestr] = FCN_ExpInitialization; % OS: OS名、Software: MATLAB/Octave、timestr: 現在の時刻の文字列


%***************************************
%       -- 色変換関数（モニタキャリブレーション情報）の読み込み --
% ハードウェアキャリブレーションを行っている人は
% 不要な可能性がある。
% ______________________________________
%load('ccmat.mat'); % 'ccmat'という変数ができる
%gamma=load('gamma.ilp');  % gamma.lut、gamma.ilutも可。色変換計算過程が違う。詳細は別途。


%***************************************
%       -- Initialization --
% ______________________________________

% キーボード設定：使いたいキーの名前をここで設定。各キーの名称はKbName関数で調べられる。
KbName('UnifyKeyNames'); % OS間のキーの名称の違いをなくす
    % 以下、例として、ESC、上矢印、左矢印の設定の例を示す
    escape = KbName('Escape');
    upkey = KbName('UpArrow');
    leftkey = KbName('LeftArrow');

% 被験者名とデータセーブファイル名
sn = input('Observer initial?: ','s');
    % ---- このあたりに、その他コマンドウィンドウから実験に必要なパラメータを入力（input関数） ----
    
datafilename = sprintf('%s_%s_%s.mat', mfilename, sn, timestr); % ここではスクリプト名、被験者名、実行日時をファイル名としているが、パラメータなども含めてファイル名から実験条件が分かるようにしておくべき


%***************************************
%       　　　-- 色変換初期化 --
% 必要に応じて、背景色や固視点の色の設定、MacLeod-Boynton色空間の
% パラメータ設定などを行う。
% パラメータの中でも色は複雑な計算が必要なので、独立項目とした。
% ______________________________________

% 以下はあくまで例。背景色のRGBを定めている。
bgrgb = [1,1,1];

%***************************************
%       -- Parameter setting --
% 必要に応じてパラメータを定義しておく。刺激サイズ、呈示時間、繰り返し回数など
% ここの数値だけいじれば実験パラメータを変えられるようにコーディングすべき
% ______________________________________

% 以下はあくまで例。順応時間を60 sと指定している
adaptsec = 60; % 順応刺激１枚あたりの呈示時間（s）
% 以下はあくまで例。刺激サイズを決めている。以下の様な情報がないとコンピュータ上での刺激サイズ（ピクセル数）が計算できない
ViewingDistance = 57; % 視距離(cm)
ScreenWidthCM = 36; % スクリーンの横幅（cm）
radiusDeg = 6; % 円形刺激の半径（視角degree）。

%***************************************
%       -- 実験手続きの設定 --
% 上下法や階段法の設定、試行回数の設定、結果記録用の
% 変数の作成などを行う。
% ______________________________________



%***************************************
%       -- try --
% 手続き中にエラーが出そうな箇所はtryに入れておくことで
% Psychtoolboxをきっちり終了させてからエラーを確認できる
% ______________________________________
try
    %***************************************************
    % 　　　　-- Psychtoolbox setup --
    % 刺激を呈示するScreenを作成する
    % __________________________________________________ 
    PsychImaging('PrepareConfiguration');
    screenid = max(Screen('Screens'));
    PsychImaging('AddTask', 'General', 'FloatingPoint32BitIfPossible'); % ハードウェアの性能が高い場合、アルファブレンディングの精度を上げる
    % Bits#をColor++モードで使いたい場合、以下のコメントを外す
    %   PsychImaging('AddTask', 'General', 'EnableBits++Color++Output',2);
    % Bits#をBits++モードで使いたい場合、以下のコメントを外す
    %   PsychImaging('AddTask', 'General', 'EnableBits++Bits++Output');
    [win, winRect] = PsychImaging('OpenWindow', screenid, 0); % 上記のAddTaskの設定に応じてWindowをオープンする
    Priority(MaxPriority(win)); % OSのScreenに対するタスク優先度を最大にし、描画リアルタイム性を上げる
    [offwin1,offwinrect]=Screen('OpenOffscreenWindow',win, 0); % このOffwin1変数はオフスクリーンで、DrawOval関数などで直接描画できるメリットあり。使う人は使うはず。
    
    
    %***************************************************
    % 　　　　-- スクリーン情報の読み込み --
    % 状況により、これらスクリーンに関する時空間情報を使うことが多い。
    % 刺激のピクセル数計算、刺激を呈示するフレーム数の計算など。
    % __________________________________________________     
    [winwidth, winheight]=Screen('WindowSize', win); % スクリーンのピクセルサイズ 
    [cx,cy]=RectCenter(winRect); % スクリーンの中央座標
    FlipInterval = Screen('GetFlipInterval', win); % モニタ１フレームの時間
    RefleshRate = 1./FlipInterval; % モニタ
   
    
    %***************************************************
    % 　　　　-- Sound setup --
    % Psychtoolboxの音のセットアップ。
    % __________________________________________________ 
    % 音の作成。あくまで一例。MakeBeep関数を使わずwavファイルから読み込むことも可(psychwavread関数を使うと良い)。
        % パラメータ
        sr = 44100; % サンプリングレート
        beeptime = 0.1; % 秒
        freq = 1000; % Hz
    mybeep = 0.5 * MakeBeep(freq, beeptime, sr); % 音の波形ができる
    mybeep = repmat(mybeep, [2, 1]);
    
    % Psychtoolboxの音設定の初期化
    InitializePsychSound(1);
    ps.pahandle = PsychPortAudio('Open');
    ps.mybeep = mybeep;
    PsychPortAudio('FillBuffer', ps.pahandle, ps.mybeep); % 音をサウンドバッファーに格納（まだ鳴らない）
    startTime = PsychPortAudio('Start', ps.pahandle); % 音を鳴らす。一回鳴らしておくと次回は時間遅れがなく音が鳴る
    
    
    %***************************************************
    % 　　　　-- Other setups --
    % 他のPsychtoolbox関連でセットアップが必要ならここに。
    % __________________________________________________     
    % マウスカーソルを隠す:
    HideCursor(screenid);
    
        
    %***************************************************
    %           -- 実験最終準備 --
    % __________________________________________________         

    % 以下は一例。被験者がクリックすると実験が始まるようにする
    % Text for observer ready
    mytext = 'Click to start experiment';
    Screen('TextSize', win, 50);
    Screen('FillRect', win, [0 0 0]); % スクリーンを黒く塗る
    DrawFormattedText(win, mytext, 'center', 'center',[255 255 255]); % 文字描画
    ts = Screen('Flip',win);  % 実際に描画
    
    % Wait for observer's click
    [clicks,x,y,whichButton] =GetClicks;
    
    %***************************************************
    %           -- 背景順応 --
    % 多くの実験で、実験前に背景やノイズ等に順応させることになる。
    % ここには、それを記述する。
    % __________________________________________________       
    
    
    %***************************************************
    %               -- 実験手続き --
    % 実験の本体。刺激呈示、被験者応答、結果記録の繰り返しなど。
    % 上下法を使うなら、TN toolboxの「NormalStair」を使うと多分ラク。
    % __________________________________________________      
    
    %%%%% forまたはwhileループで試行を繰り返す %%%%%%%%%%%%%%%%%%%%
    
    
    %%%%% 色の計算や刺激の準備 %%%%%%%%%%%%%%%%%%%%
        % 各試行を行った時刻も必ずファイルに保存しなければならないので、試行の日時取得。
    if strcmp(Software, 'MATLAB')
        t = clock; % for Mac
        timestr = sprintf('%d-%d-%d(%d-%d)', t(1),t(2),t(3),t(4),t(5)); % for Mac
    elseif strcmp(Software, 'Octave')
        t = localtime(time()-9*60*60); % for Octave
        timestr = sprintf('%03d-%02d-%02d(%02d-%02d)',t.year, t.mon+1,t.mday,t.hour,t.min); %for Octave
    end
    
    
    %%%%% 刺激の呈示 %%%%%%%%%%%%%%%%%%%%
    
    % for Bits# Bits++モードユーザー
    % LUTを'clut'という変数に置いたとすると、
    %   Screen('LoadNormalizedGammaTable', windowPtr, baseclut, 2);
    % と書くだけでLUTがBits#に反映される（T-Lockコードが自動的にスクリーンに描画される）
    
    % for BIts# Colour++モードユーザー
    % 通常通りモニタに0<rgb<1の範囲で描画することで、左右ピクセルが平均化され、14bitのRGBで表示される。
    % 自動的に隣合うピクセルが平均化されてしまうことに注意。
    
    %%%%% 被験者応答の取得 %%%%%%%%%%%%%%%%%%%%
    % 以下は一例。マウスとキーボードで応答を取る
        % 被験者がマウスボタンを一度離していることを確認。
    [x,y,buttons] = GetMouse;
    while any(buttons) 
        [x,y,buttons] = GetMouse;
    end
    
        % 被験者応答
    keyIsDown = 0;
    while ~any(buttons) && ~keyIsDown % マウスかキーボードが押されるまでループ
        SetMouse(500,500); % マウスの位置を固定する
        [x,y,buttons] = GetMouse; % マウス応答の取得（buttons変数）
        [ keyIsDown, seconds, keyCode ] = KbCheck(-1); % キーボード応答を取得（keyCode変数）： -1 means checking all keyboards
        if keyIsDown && keyCode(escape) % ESCキーが押されたらフラグを立てる（実験を途中で終える場合などに使える）
            flag = 1;
            break;
        end
    end    
        
    
    %%%%% 被験者応答の判断（正誤判定など） %%%%%%%%%%%%%%%%%%%%
    
        startTime = PsychPortAudio('Start', ps.pahandle ); % 被験者に音でフィードバックを出したりする
    
    %%%%% 実験結果の変数への格納、ファイルへの記録。できれば毎試行格納する。 %%%%%%%%%%%%%%%%%%%%
    
    %%%%% ループの処理、判定（実験が終わりなのか、次の条件に行くのか） %%%%%%%%%%%%%%%%%%%%
    
    
    
    %***************************************************
    %                 -- Clean up --
    % 
    % __________________________________________________    

    FCN_ExpFinalization(screenid); % Psychtoolboxのお片づけ
    
%***************************************************
%     -- In case any errors occurs... --
% __________________________________________________       
catch
    FCN_ExpFinalization(screenid);

    psychrethrow(psychlasterror); % エラーの表示
end