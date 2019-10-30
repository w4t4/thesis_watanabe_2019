% DKL2lms (ver1.0)  
% 
% CalculateLMS values from DKL coodinates.
%
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Usage: 
%    lms = DKL2lms(DKL, stdlms, thr);
%   
% Input:  
%   DKL:    DKL matrix, ([0.1; 0.2; 0.5] or [0.2 0.3; 0.4 0.3; 0.4 0.5], these values are DKL coodinates after normalization by thresholds)
%   stdlms: LMS matrix of neutral point subject adapted to (ex. [0.1; 0.07; 0.09])
%   thr:    detection/discrimination thresholds on each axis of DKL space (ex. [0.1; 0.07; 0.09])
% Output:
%   lms:    LMS matrix (the same size as the DKL matrix)
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%
% Created by Takehiro Nagai on 06/05/2009 (ver.1)
% 

function lms = DKL2lms(DKL, stdlms, thr)

% make matrix of standard LMS values and thresholds
colmunlen = size(DKL,2);
stdlmsmat = repmat(stdlms, 1, colmunlen);
thrmat = repmat(thr, 1, colmunlen);

% denormalization of each axis
DKLb = DKL.*thrmat;

% calculate cone contrasts
lmsc = [(DKLb(1,:)+DKLb(2,:))./2; (DKLb(1,:)-DKLb(2,:))./2; (DKLb(1,:)+DKLb(3,:))./2];

% calculate LMS values using neutral LMS values
lms = lmsc.*stdlmsmat + stdlmsmat;





