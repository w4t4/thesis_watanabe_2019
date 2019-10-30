% FindGamutLimitation (ver.1.0)
%
% Find G
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Usage:
%       result = FindGamutLimitation(dklthr, ccmat, reflms)
% 
% Input:
%       dklthr: temporary thresholds for DKL axis scaling (usually [1; 1; 1])
%       ccmat:  ccmat file for ColorConversion functions
%       reflms: reference lms for DKL origin
%
% Output:
%       result: Estimated threshold.
%
% Other explanation:
%     If there is any suggestions, write them here.
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Created by Takehiro Nagai on 05/15/2010 (ver.1)
%



function result = FindGamutLimitation(dklthr, ccmat, reflms)
    result = zeros(3,2); % rgb, +-
    for cdir = 1:3  % Lum, L-M, S
        % + direction
        for pm = 1:2
            step = 1;
            cdkl = [0; 0; 0];
            while step>0.00001
                % fprintf('current step: %f, current thr: %f\n', step, cdkl(cdir));
                flag = 1;
                while flag
                    tdkl = cdkl;
                    switch pm
                        case 1
                            tdkl(cdir) = tdkl(cdir) + step;
                        case 2
                            tdkl(cdir) = tdkl(cdir) - step;
                    end
                    tlms = DKL2lms_mod(tdkl, reflms, dklthr);
                    trgb = lms2rgb(tlms, ccmat);
                    % fprintf('DKL:(%f %f %f), RGB:(%f %f %f)\n', ...
                    %     tdkl(1),tdkl(2),tdkl(3),trgb(1),trgb(2),trgb(3));
                    if min(trgb)<0 || max(trgb)>1
                        step = step/2;
                        flag = 0;
                    else
                        cdkl = tdkl;
                    end
                end
            end
            result(cdir, pm)=cdkl(cdir);
        end
    end
end