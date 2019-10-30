function [FreeParams, negLL, exitflag, output] = FCN_TNminimize_negLL(InitValues, minV, maxV, options, cmbs, NumGreater, OutOfNum);

minvs = minV .* ones(1, length(InitValues));
maxvs = maxV .* ones(1, length(InitValues));
[FreeParams, negLL, exitflag, output] = fmincon(@nestedfun, InitValues, [],[],[],[],minvs,maxvs,[],options);

    function negLL = nestedfun(FreeParams)
        distance = [0 FreeParams]';

        D = distance(cmbs(:,1)) - distance(cmbs(:,2));
        

        Z_D = D'; % make perceptual difference when SD=1
        pFirst = .5 + .5*(1-erfc(Z_D./sqrt(2))); % �S������֐��i�����m���֐��j�֕ϊ��Bsqrt(2)�͐��K���z�̑������킹�l��
        % pFirst = pFirst.*0.98+0.01; % failed...

        negLL = -sum(NumGreater(NumGreater > 0).*log(pFirst(NumGreater > 0)))-sum((OutOfNum(NumGreater < OutOfNum)-NumGreater(NumGreater < OutOfNum)).*log(1-pFirst(NumGreater < OutOfNum)));        
    end

end