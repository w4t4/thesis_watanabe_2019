% DKL2lms_mod (ver2.0)  
% 
% CalculateLMS values from DKL coodinates (Normalized by luminance values).
%
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Usage: 
%    lms = DKL2lms_mod(DKL, stdlms, thr);
%   
% Input:  
%   DKL:    DKL matrix, ([0.1; 0.2; 0.5] or [0.2 0.3; 0.4 0.3; 0.4 0.5], these values are DKL coodinates after normalization by thresholds)
%   stdlms: LMS matrix of neutral point subject adapted to (ex. [0.1; 0.07; 0.09])
%   thr:    detection/discrimination thresholds on each axis of DKL space (ex. [0.1; 0.07; 0.09])
%
% Output:
%   lms:    LMS matrix (the same size as the DKL matrix)
%
% Comments:
%   This script is somewhat different from DKL space in Brainard (1996).
%    1. Normalization of the axes is based on detection thresholds.
%    2. L-M and S axis is normalized by "L+M(psychophysical luminance
%       value, not DKL value)" to compensate chromaticy differences due to
%       luminance difference
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%
% Created by Takehiro Nagai on 06/05/2009 (ver.1)
% Modified by Takehiro Nagai on 06/05/2009 (ver.2): based on Brainard(1996)
% 

function lms = DKL2lms_mod(DKL, stdlms, thr)

% calculate coefficient to normalize chromatic axes
a = (DKL(1,:)).*thr(1) + stdlms(1) + stdlms(2);

% calculate lms values
lmsc = [(stdlms(1).*(DKL(1,:).*thr(1)) + stdlms(2).*(DKL(2,:).*a.*thr(2)) ) / (stdlms(1)+stdlms(2));...
        (stdlms(2).*(DKL(1,:).*thr(1)) - stdlms(2).*(DKL(2,:).*a.*thr(2)) ) / (stdlms(1)+stdlms(2));...
        (stdlms(3).*(DKL(1,:).*thr(1)) + stdlms(3).*(DKL(3,:).*a.*thr(3)) ) / (stdlms(1)+stdlms(2));...
        ];

colmunlen = size(DKL,2);
stdlmsmat = repmat(stdlms, 1, colmunlen);
lms = lmsc + stdlmsmat;

end







