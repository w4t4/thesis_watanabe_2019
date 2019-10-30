% DKL2rgb (ver1.0)  
% 
% Calculate rgb values (0-1) from DKL coodinates.
%
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Usage: 
%    rgb = DKL2rgb(DKL, stdlms, thr, ccmat);
%   
% Input:  
%   DKL:    DKL matrix, ([0.1; 0.2; 0.5] or [0.2 0.3; 0.4 0.3; 0.4 0.5], these values are DKL coodinates after normalization by thresholds)
%   stdlms: LMS matrix of neutral point subject adapted to (ex. [0.1; 0.07; 0.09])
%   thr:    detection/discrimination thresholds on each axis of DKL space (ex. [0.1; 0.07; 0.09])
%   ccmat:  color conversion matrix created by makeccmatrix.m
% Output:
%   rgb:    rgb vector or matrix (the same size as the DKL matrix)
%
% Comments:
%   This script is somewhat different from DKL space in Brainard (1996).
%    1. Normalization of the axes is based on detection thresholds.
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%
% Created by Takehiro Nagai on 11/05/2010 (ver.1)
% 

function rgb = DKL2rgb(DKL, stdlms, thr, ccmat)

lms = DKL2lms(DKL, stdlms, thr);
rgb = lms2rgb(lms, ccmat);








