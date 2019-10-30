% lms2DKL_mod (ver2)  
% 
% Calculate DKL coodinates from LMS value (Normalized by luminance values)
%
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Usage: 
%    DKL = lms2DKL_mod(lms, stdlms, thr);
%   
% Input:  
%   lms:    LMS matrix, ([0.1 0.2 0.5] or [0.2 0.3 0.4;  0.3 0.4 0.5], these values are calculated just by multiplying cone fundamentals and spectral radiance)
%   stdlms: LMS matrix of neutral point subject adapted to (ex. [0.1 0.07 0.09])
%   thr:    detection/discrimination thresholds on each axis of DKL space (ex. [0.1 0.07 0.09])
% Output:
%   DKL:  DKL matrix (the same size as the lms matrix)
%
% Comments:
%   This script is somewhat different from DKL space in Brainard (1996).
%    1. Normalization of the axes is based on detection thresholds.
%    2. L-M and S axes are normalized by "L+M(psychophysical luminance
%       value, not DKL value)" to compensate chromaticy differences due to
%       luminance difference
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%
% Created by Takehiro Nagai on 06/05/2009 (ver.1)
% Modified by Takehiro Nagai on 04/21/2010 (ver.2): Equations were changed based on Brainard (1996)
%

function DKL = lms2DKL_mod(lms, stdlms, thr)


% calculate cone difference against standard LMS values
colmunlen = size(lms,2);
stdlmsmat = repmat(stdlms, 1, colmunlen);
lmsc = lms-stdlmsmat;

% calculate coefficient to normalize chromatic axes
a = (lmsc(1,:)+lmsc(2,:)).*thr(1) + stdlms(1) + stdlms(2);

% calculate basic DKL coodinates (normalized by thresholds)
DKL = [(lmsc(1,:)+lmsc(2,:))./thr(1);...
        (lmsc(1,:)-lmsc(2,:).*stdlms(1)./stdlms(2))./a./thr(2);...
        (((stdlms(1)+stdlms(2))./stdlms(3)).*lmsc(3,:)-(lmsc(1,:)+lmsc(2,:)))./a./thr(3);
    ];





