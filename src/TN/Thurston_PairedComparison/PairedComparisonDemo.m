%% Initialization
clear all
more off

% choose ML method
fprintf('What ML method are you using?\n')
fprintf('   [1] Custimozed fminsearch in MLDS method\n');
fprintf('   [2] Normal fminsearch\n');
fprintf('   [3] fmincon for parameter range limitation (MATLAB only)\n');
method = input('Please enter 1, 2, or 3 (default: 3):   ');

% parameter setting
B = 400; % Repetition number in Boostrap
tnum = 2; % trial number in each stimulus pair in Psychophyiscal experiment


% make ground truth (psychological values such as 'glossiness')
% GroundTruth = randn(1,35).*1.5;
GroundTruth = rand(1,35).*4-2;


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
[mtx, OutOfNum, NumGreater] = FCN_ObsResSimulation(GroundTruth, cmbs, tnum, 1); % �Ō��1�́A���o�̕W���΍��i�P�[�XV�ɍ��킹��1�j

% Analysis 1: Thurstaon's case V model based on z-score�i�T�[�X�g���̈�Δ�r�@�P�[�XV���f���B��@���V���v���ȕ��A��͌��ʂ������c�ށj
estimated_sv = FCN_PCanalysis_Thurston(mtx, 0.005);
estimated_sv = estimated_sv - mean(estimated_sv);

% Analysis 2: Maximum likelihood method�i�Ŗޖ@�B�f�[�^�̓����ɑ΂��f�[�^�����\���Ȃ�i����𖞂����Ă��邩�����Ȃ̂����j�A�T�[�X�g�����f����萸�x�������j
InitValues = estimated_sv - estimated_sv(1); % �T�[�X�g���̌��ʂ������l�ɐݒ�B�������A�ō��l��0�ɂȂ�悤���K���i���R�x��������j
[estimated_sv2,NumGreater_v,OutOfNum_v] = FCN_PCanalysis_ML(OutOfNum, NumGreater, cmbs, InitValues, method);
estimated_sv2 = estimated_sv2 - mean(estimated_sv2);

fprintf('....Done!!\n\n\n');    if IsOctave, fflush(1); end
WaitSecs(0.8);


%% Bootstrap analysis 
fprintf('Bootstrap analysis:\n');
fprintf('  Bootstrap repetition number: %d\n\n\n', B);
if IsOctave, fflush(1); end

% �u�[�g�X�g���b�v�T���v���ۑ��ϐ�
sv_th = zeros(B, stimnum); % �d�v�F�T�[�X�g���̈�Δ�r�@�ɂ��u�[�g�X�g���b�v�T���v���B�X���̌���ȂǂɎg���f�[�^�Ȃ̂ŕۑ��K�{�B�� �T�[�X�g���ł͌��ʂ��c�ށi�o�C�A�X��������j�̂Ńu�[�g�X�g���b�v�����܂������Ȃ�
sv_ml = zeros(B, stimnum); % �d�v�F�Ŗޖ@�ɂ��u�[�g�X�g���b�v�T���v���B�X���̌���ȂǂɎg���f�[�^�Ȃ̂ŕۑ��K�{�B�� �����炪�x�^�[���B

pg = 1;
for b=1:B % �u�[�g�X�g���b�v�T���v���̍쐬�F�v�c��ȏ�������
    % show progress
    if b/B>pg*0.05
        fprintf('   progress...%2.0f%%\n', pg*0.05*100);if IsOctave, fflush(1); end
        pg = pg+1;
    end

    % �팱�҉����V�~�����[�V�����P: �T�[�X�g���̈�Δ�r�̌��ʂ��u�[�g�X�g���b�v�I
    [mtx_s, OutOfNum_s, NumGreater_s] = FCN_ObsResSimulation(estimated_sv, cmbs, tnum, 1); % �Ō��1�́A���o�̕W���΍��i�P�[�XV�ɍ��킹��1�j

    % �������ʂ̉�́F��@�P�i�T�[�X�g���̈�Δ�r�@�P�[�XV���f���j
    sv_th(b,:) = FCN_PCanalysis_Thurston(mtx_s, 0.005);
    sv_th(b,:) = sv_th(b,:) - mean(sv_th(b,:));
    
    
    % �팱�҉����V�~�����[�V�����Q�F�Ŗޖ@�̌��ʂ��u�[�g�X�g���b�v�I
    [mtx_s, OutOfNum_s, NumGreater_s] = FCN_ObsResSimulation(estimated_sv2, cmbs, tnum, 1); % �Ō��1�́A���o�̕W���΍��i�P�[�XV�ɍ��킹��1�j

    % �\����́i�T�[�X�g���̈�Δ�r�@�P�[�XV���f���j
    prediction = FCN_PCanalysis_Thurston(mtx_s, 0.005);
    
    % �������ʂ̉�́F��@�Q�i�Ŗޖ@�j
    InitValues = prediction - prediction(1); % �T�[�X�g���̌��ʂ������l�ɐݒ�B�������A�ō��l��0�ɂȂ�悤���K���i���R�x��������j
    [sv_ml(b,:), dummy1, dummy2] = FCN_PCanalysis_ML(OutOfNum_s, NumGreater_s, cmbs, InitValues, method);
    sv_ml(b,:) = sv_ml(b,:) - mean(sv_ml(b,:));    
end

% �P���ȕW���덷�F����o�C�A�X���l����ƕs�K��
ses_th = std(sv_th); % �W���덷 by �T�[�X�g����Δ�r�@
ses_ml = std(sv_ml); % �W���덷 by �Ŗޖ@
fprintf('....Done!!\n\n\n');   if IsOctave, fflush(1); end

% �u�[�g�X�g���b�v�T���v���Ɋ�Â�68%�M�����
ranges68_th = zeros(stimnum, 3); % 68�M����ԁ@by �T�[�X�g����Δ�r�@
ranges68_ml = zeros(stimnum, 3); % 68�M����ԁ@by �Ŗޖ@
ubi = round(B*84/100);
lbi = round(B*16/100);
mi = round(B./2);
for s=1:stimnum
    % �T�[�X�g���f�[�^
    sdata = sort(sv_th(:,s));
    ranges68_th(s,1) = sdata(lbi)-sdata(mi); % lower bound
    ranges68_th(s,2) = sdata(ubi)-sdata(mi); % upper bound
    ranges68_th(s,3) = sdata(mi);
    
    % MLdata
    sdata = sort(sv_ml(:,s));
    ranges68_ml(s,1) = sdata(lbi)-sdata(mi); % lower bound
    ranges68_ml(s,2) = sdata(ubi)-sdata(mi); % upper bound
    ranges68_ml(s,3) = sdata(mi);
end

%% ���ʂ̃v���b�g
% �T�[�X�g���ƍŖޖ@�̌��ʂ̔�r: �G���[�o�[������l
figure('Position',[1 1 800 300], 'Name', 'Ground truth vs Estimated')
subplot(1,2,1); hold on;
plot(GroundTruth, estimated_sv, 'ok');
% errorbar(GroundTruth, estimated_sv, ses_th, '.k'); % �����ł͕W���덷���g���Ă��邪�A68 or 95%�M����Ԃ̕��������ǂ�
errorbar(GroundTruth, ranges68_th(:,3), -ranges68_th(:,1), ranges68_th(:,2), '.k'); % 68%�M�����
plot([-4 4], [-4 4],'--k')
    title('Estimated by Thurston method')
    xlabel('Ground truth');
    ylabel('Estimated sensation value');
subplot(1,2,2); hold on;
plot(GroundTruth, estimated_sv2, 'ok');
% errorbar(GroundTruth, estimated_sv2, ses_ml, '.k'); % �����ł͕W���덷���g���Ă��邪�A68 or 95%�M����Ԃ̕��������ǂ�
errorbar(GroundTruth, ranges68_ml(:,3), -ranges68_ml(:,1), ranges68_ml(:,2), '.k'); % 68%�M�����
plot([-4 4], [-4 4],'--k')
    title('Estimated by maximum likelihood method')
    xlabel('Ground truth');
    ylabel('Estimated sensation value');

    
% �ŏ����o�_�̐���l�̃q�X�g�O����    
[dummy, index] = min(GroundTruth);
figure('Position',[1 1 800 300], 'Name', 'Histogram of estimated values')
subplot(1,2,1); hold on;
    hist(sv_th(:,index), 20);
    title('Thurston method');

subplot(1,2,2); hold on;
    hist(sv_ml(:,index), 20);
    title('Maximum likelihood');


% �팱�҂̉����m���ƍŖސ��胂�f���̉����m���̔�r
params = estimated_sv2 - estimated_sv2(1);
dummy = FCN_MLDS_negLL(params(2:end), cmbs, NumGreater_v, OutOfNum_v, 1);
    
    
