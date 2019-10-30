function [ps,NumGreater_v,OutOfNum_v] = FCN_PCanalysis_ML(OutOfNum, NumGreater, cmbs, InitValues, method)

stimnum = size(OutOfNum, 1);

% ŽÀŒ±Œ‹‰Ê‚ÌŽhŒƒ‘Î‚ÉŠî‚Ã‚­ƒxƒNƒgƒ‹‰»
NumGreater_v = zeros(1, size(cmbs,1));
OutOfNum_v = zeros(1, size(cmbs,1));

for c = 1:length(NumGreater_v)
    NumGreater_v(c) = NumGreater(cmbs(c,1),cmbs(c,2));
    OutOfNum_v(c) = OutOfNum(cmbs(c,1),cmbs(c,2));
end

% ML analytis
[ps, output, exitflag] = FCN_MLDSanalysis(cmbs, NumGreater_v, OutOfNum_v, InitValues, method);

