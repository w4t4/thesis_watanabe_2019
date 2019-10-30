% lms2DKL (ver1.0)  
% 
% Calculate DKL coodinates from LMS value.
%
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Usage: 
%    DKL = lms2DKL(lms, stdlms, thr);
%   
% Input:  
%   lms:    LMS matrix, ([0.1 0.2 0.5] or [0.2 0.3 0.4;  0.3 0.4 0.5], these values are calculated just by multiplying cone fundamentals and spectral radiance)
%   stdlms: LMS matrix of neutral point subject adapted to (ex. [0.1 0.07 0.09])
%   thr:    detection/discrimination thresholds on each axis of DKL space (ex. [0.1 0.07 0.09])
% Output:
%   DKL:  DKL matrix (the same size as the lms matrix)
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%
% Created by Takehiro Nagai on 06/05/2009 (ver.1)
% 

function DKL = lms2DKL_old(lms, stdlms, thr)

% make matrix of standard LMS values and thresholds
colmunlen = size(lms,2);
stdlmsmat = repmat(stdlms, 1, colmunlen);
thrmat = repmat(thr, 1, colmunlen);

% calculate cone contrasts against standard LMS values
lmsc = (lms-stdlmsmat)./stdlmsmat;

% calculate basic DKL coodinates (not normalized by thresholds)
DKLb = [lmsc(1,:)+lmsc(2,:); lmsc(1,:)-lmsc(2,:); 2.*lmsc(3,:)-(lmsc(1,:)+lmsc(2,:))];

% normalization of each axis
DKL = DKLb./thrmat;



