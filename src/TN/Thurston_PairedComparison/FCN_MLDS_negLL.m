%
%PAL_MLDS_negLL (negative) Log Likelihood for MLDS fit.
%
%syntax: [negLL] = PAL_MLDS_negLL(FreeParams, stim, NumGreater, OutOfNum)
%
%Internal function
%
%Introduced: Palamedes version 1.0.0 (NP)

function negLL = FCN_MLDS_negLL(FreeParams, cmbs, NumGreater, OutOfNum, ploton)

distance = [0 FreeParams]';

D = distance(cmbs(:,1)) - distance(cmbs(:,2));
    
Z_D = D'; % make perceptual difference when SD=1
pFirst = .5 + .5*(1-erfc(Z_D./sqrt(2))); % 心理測定関数（応答確率関数）へ変換。sqrt(2)は正規分布の足しあわせ考慮
pFirst = pFirst.*0.96+0.02;

negLL = -sum(NumGreater(NumGreater > 0).*log(pFirst(NumGreater > 0)))-sum((OutOfNum(NumGreater < OutOfNum)-NumGreater(NumGreater < OutOfNum)).*log(1-pFirst(NumGreater < OutOfNum)));

if ploton
    figure('Name', 'Psychometric function');

    hold on
    
    plot(D, NumGreater./OutOfNum, 'ok'); % 被験者の応答確率
    
    [x, ind] = sort(D);% モデル確率に沿って刺激ペアを並びかえ
    y = pFirst(ind);
    plot(x,y, 'r-'); % 推定モデルの応答確率
    xlabel('Sensational Difference in stimulus pair')
    ylabel('Response probability');
end



