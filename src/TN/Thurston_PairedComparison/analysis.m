%% Initialization
%clear all
more off

% choose ML method
fprintf('What ML method are you using?\n')
fprintf('   [1] Custimozed fminsearch in MLDS method\n');
fprintf('   [2] Normal fminsearch\n');
fprintf('   [3] fmincon for parameter range limitation (MATLAB only)\n');
method = input('Please enter 1, 2, or 3 (default: 3):   ');

% parameter setting
B = 1000; % Repetition number in Boostrap
tnum = 2; % trial number in each stimulus pair in Psychophyiscal experiment

% make ground truth (psychological values such as 'glossiness')
% GroundTruth = randn(1,35).*1.5;
GroundTruth = rand(1,9).*4-2;


% make stimulus pairs
stimnum = length(GroundTruth);
cmbs = zeros((stimnum*(stimnum-1)./2), 2);
combinum = size(cmbs,1);
count = 1;
for a = 1:stimnum-1
    for b = a+1:stimnum
        cmbs(count,1) = a;
        cmbs(count,2) = b;
        count = count + 1;
    end
end

% show some info
fprintf('Ground truths of sensation values were created.\n');
fprintf('   Number of stimulus: %d\n', stimnum);
fprintf('   Number of stimulus combinations: %d\n\n', combinum);
if IsOctave, fflush(1); end

WaitSecs(0.2);

fprintf('Trial number per condition: %d\n\n\n', tnum);
if IsOctave, fflush(1); end

%% Simulation of a psychophysical paired comparison experiment
fprintf('Simulation of psychophysical experiment\n'); if IsOctave, fflush(1); end
%[mtx, OutOfNum, NumGreater] = FCN_ObsResSimulation(GroundTruth, cmbs, tnum, 1); % 最後の1は、感覚の標準偏差（ケースVに合わせて1）
NumGreater = vTable(:,:,4);
OutOfNum = (ones(size(vTable))-eye(size(vTable,1)))*tnum;
mtx = NumGreater./ones(size(vTable))/tnum+eye(size(vTable,1))*0.5;


% Analysis 1: Thurstaon's case V model based on z-score（サーストンの一対比較法ケースVモデル。手法がシンプルな分、解析結果が少し歪む）
estimated_sv = FCN_PCanalysis_Thurston(mtx, 0.005);
estimated_sv = estimated_sv - mean(estimated_sv);

% Analysis 2: Maximum likelihood method（最尤法。データの特徴に対しデータ数が十分なら（これを満たしているか微妙なのだが）、サーストンモデルより精度が高い）
InitValues = estimated_sv - estimated_sv(1); % サーストンの結果を初期値に設定。ただし、最左値が0になるよう正規化（自由度を下げる）
[estimated_sv2,NumGreater_v,OutOfNum_v] = FCN_PCanalysis_ML(OutOfNum, NumGreater, cmbs, InitValues, method);
estimated_sv2 = estimated_sv2 - mean(estimated_sv2);

fprintf('....Done!!\n\n\n');    if IsOctave, fflush(1); end
WaitSecs(0.8);


%% Bootstrap analysis 
fprintf('Bootstrap analysis:\n');
fprintf('  Bootstrap repetition number: %d\n\n\n', B);
if IsOctave, fflush(1); end

% ブートストラップサンプル保存変数
sv_th = zeros(B, stimnum); % 重要：サーストンの一対比較法によるブートストラップサンプル。傾きの検定などに使うデータなので保存必須。→ サーストンでは結果が歪む（バイアスがかかる）のでブートストラップもうまくいかない
sv_ml = zeros(B, stimnum); % 重要：最尤法によるブートストラップサンプル。傾きの検定などに使うデータなので保存必須。→ こちらがベターか。

pg = 1;
for b=1:B % ブートストラップサンプルの作成：要膨大な処理時間
    % show progress
    if b/B>pg*0.05
        fprintf('   progress...%2.0f%%\n', pg*0.05*100);if IsOctave, fflush(1); end
        pg = pg+1;
    end

    % 被験者応答シミュレーション１: サーストンの一対比較の結果をブートストラップ！
    [mtx_s, OutOfNum_s, NumGreater_s] = FCN_ObsResSimulation(estimated_sv, cmbs, tnum, 1); % 最後の1は、感覚の標準偏差（ケースVに合わせて1）
    
    
    

    % 実験結果の解析：手法１（サーストンの一対比較法ケースVモデル）
    sv_th(b,:) = FCN_PCanalysis_Thurston(mtx_s, 0.005);
    sv_th(b,:) = sv_th(b,:) - mean(sv_th(b,:));
    
    
    % 被験者応答シミュレーション２：最尤法の結果をブートストラップ！
    [mtx_s, OutOfNum_s, NumGreater_s] = FCN_ObsResSimulation(estimated_sv2, cmbs, tnum, 1); % 最後の1は、感覚の標準偏差（ケースVに合わせて1）

    % 予備解析（サーストンの一対比較法ケースVモデル）
    prediction = FCN_PCanalysis_Thurston(mtx_s, 0.005);
    
    % 実験結果の解析：手法２（最尤法）
    InitValues = prediction - prediction(1); % サーストンの結果を初期値に設定。ただし、最左値が0になるよう正規化（自由度を下げる）
    [sv_ml(b,:), dummy1, dummy2] = FCN_PCanalysis_ML(OutOfNum_s, NumGreater_s, cmbs, InitValues, method);
    sv_ml(b,:) = sv_ml(b,:) - mean(sv_ml(b,:));    
end

% 単純な標準誤差：推定バイアスを考えると不適切
ses_th = std(sv_th); % 標準誤差 by サーストン一対比較法
ses_ml = std(sv_ml); % 標準誤差 by 最尤法
fprintf('....Done!!\n\n\n');   if IsOctave, fflush(1); end

% ブートストラップサンプルに基づく68%信頼区間
ranges95_th = zeros(stimnum, 3); % 68信頼区間　by サーストン一対比較法
ranges95_ml = zeros(stimnum, 3); % 68信頼区間　by 最尤法
ubi = round(B*97.5/100);
lbi = round(B*2.5/100);
mi = round(B./2);
for s=1:stimnum
    % サーストンデータ
    sdata = sort(sv_th(:,s));
    ranges95_th(s,1) = sdata(lbi)-sdata(mi); % lower bound
    ranges95_th(s,2) = sdata(ubi)-sdata(mi); % upper bound
    ranges95_th(s,3) = sdata(mi);
    
    % MLdata
    sdata = sort(sv_ml(:,s));
    ranges95_ml(s,1) = sdata(lbi)-sdata(mi); % lower bound
    ranges95_ml(s,2) = sdata(ubi)-sdata(mi); % upper bound
    ranges95_ml(s,3) = sdata(mi);
end

%% 結果のプロット
% サーストンと最尤法の結果の比較: エラーバーつき推定値
figure('Position',[1 1 800 300], 'Name', 'Ground truth vs Estimated')
sn = [1 2 3 4 5 6 7 8 9];
hold on;
errorbar(sn, ranges95_ml(:,3), -ranges95_ml(:,1), ranges95_ml(:,2), '.k'); % 95%信頼区間
hold on;
xlim([0 9])
plot(sn, estimated_sv, 'ok');
    
% 被験者の応答確率と最尤推定モデルの応答確率の比較
% params = estimated_sv2 - estimated_sv2(1);
% dummy = FCN_MLDS_negLL(params(2:end), cmbs, NumGreater_v, OutOfNum_v, 1);
    
    