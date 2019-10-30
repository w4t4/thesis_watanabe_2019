% lms2DKL_normalize_test (ver1.0)  
% 
% Calculate DKL coodinates from LMS value.
% This function modified the original DKL space
% to prevent chromaticity differences between 
% different luminance values.
% 
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Usage: 
%    DKL = lms2DKL_normalize_test(lms, stdlms, thr);
%   
% Input:  
%   lms:    LMS matrix, ([0.1;0.2;0.5] or [0.2 0.3; 0.3 0.4; 0.4 0.5;], these values are calculated just by multiplying cone fundamentals and spectral radiance)
%   stdlms: LMS matrix of neutral point subject adapted to (ex. [0.1;0.07;0.09])
%   thr:    detection/discrimination thresholds on each axis of DKL space (ex. [0.1;0.07;0.09])
% Output:
%   DKL:  DKL matrix (the same size as the lms matrix)
%
% Comments:
%   Luminance: 1.5*(dL/L0)+(dM/M0)
%   L-M: ((dL/L0)-(dM/M0))/((dL/L0)+(dM/M0)+2)
%   S: (2S-((dL/L0)+(dM/M0)))/((dL/L0)+(dM/M0)+2)
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%
% Created by Takehiro Nagai on 07/19/2016 (ver.1)
%

function DKL = lms2DKL_normalize_test(lms, stdlms, thr)


% calculate cone difference against standard LMS values
colmunlen = size(lms,2);
stdlmsmat = repmat(stdlms, 1, colmunlen);
lmsc = (lms-stdlmsmat)./stdlmsmat;

% calculate basic DKL coodinates (normalized by thresholds)
DKL = [(1.5.*lmsc(1,:)+lmsc(2,:))./thr(1);...
        ((lmsc(1,:)-lmsc(2,:))./((lmsc(1,:)+lmsc(2,:))+2))./thr(2);...
        ((2.*lmsc(3,:)-(lmsc(1,:)+lmsc(2,:)))./((lmsc(1,:)+lmsc(2,:))+2))./thr(3);
    ];





