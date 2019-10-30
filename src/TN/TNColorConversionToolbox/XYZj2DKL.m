% XYZj2DKL (ver2.0)  
% 
% Calculate DKL coodinates from Judd-modified XYZ.
%
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Usage: 
%    lms = XYZj2DKL(DKL, stdlms, thr, ccmat);
%   
% Input:  
%   XYZ:    Judd-modified XYZ matrix ([20;26;15] or [24,27;34,18;29 42])
%   stdlms: LMS matrix of neutral point subject adapted to (ex. [0.1; 0.07; 0.09])
%   thr:    detection/discrimination thresholds on each axis of DKL space (ex. [0.1; 0.07; 0.09])
%   ccmat:  color conversion matrix created by makeccmatrix.m
% Output:
%   DKL:    DKL matrix (whose size is the same as XYZ)
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

function DKL = XYZj2DKL(XYZ, stdlms, thr, ccmat)

rgb = XYZj2rgb(XYZ, ccmat);
lms = rgb2lms(rgb, ccmat);
DKL = lms2DKL(lms, stdlms, thr);








