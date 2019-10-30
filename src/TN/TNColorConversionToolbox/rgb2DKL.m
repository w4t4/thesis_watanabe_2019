% rgb2DKL (ver1.0)  
% 
% Calculate rgb values (0-1) from DKL coodinates.
%
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Usage: 
%    rgb = rgb2DKL(DKL, stdlms, thr, ccmat);
%   
% Input:  
%   rgb:    rgb matrix, ([0.1; 0.2; 0.5] or [0.2 0.3; 0.4 0.3; 0.4 0.5], these values are DKL coodinates after normalization by thresholds)
%   stdlms: LMS matrix of neutral point subject adapted to (ex. [0.1; 0.07; 0.09])
%   thr:    detection/discrimination thresholds on each axis of DKL space (ex. [0.1; 0.07; 0.09])
%   ccmat:  color conversion matrix created by makeccmatrix.m
% Output:
%   DKL:    DKL vector or matrix (the same size as the DKL matrix)
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

function DKL = rgb2DKL(rgb, stdlms, thr, ccmat)

lms = rgb2lms(rgb, ccmat);
DKL = lms2DKL(lms, stdlms, thr);








