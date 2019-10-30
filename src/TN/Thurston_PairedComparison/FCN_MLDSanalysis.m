function [PsiValues, output, exitflag] = FCN_MLDSanalysis(cmbs, NumGreater, OutOfNum, InitValues, method)

if isempty(method)
    method = 3;
end

options = [];

switch method
    case 1
    % 1. Customized fminsearch
    [FreeParams, negLL, exitflag, output] = FCN_minimize(@FCN_MLDS_negLL, InitValues(2:end), options, cmbs, NumGreater, OutOfNum, 0);
    case 2
    % 2. fminsearch
    [FreeParams, negLL, exitflag, output] = fminsearch(@FCN_MLDS_negLL, InitValues(2:end), options, cmbs, NumGreater, OutOfNum, 0);
    case 3
    % 3. Parameter limited optimization (MATLAB only)
    options = optimoptions('fmincon','Display','off','Algorithm','sqp');
    [FreeParams, negLL, exitflag, output] = FCN_TNminimize_negLL(InitValues(2:end), -4, 4, options, cmbs, NumGreater, OutOfNum);
end

LL = -negLL;

PsiValues = InitValues;
PsiValues(2:end) = FreeParams;


