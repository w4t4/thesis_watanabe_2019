% rgb2lms (ver1.0)  
% 
% Calculate lms values from rgb values.
%
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Usage: 
%    lms = rgb2lms(rgb, ccmat);
%   
% Input:  
%   rgb:    rgb vector or matrices ([0.8;0.5;0.6] or [0.7,0.4;0.9,0.8;0.7 0.5])
%   ccmat:  color conversion matrix created by makeccmatrix.m
% Output:
%   lms:    lms vector or matrices
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%
% Created by Takehiro Nagai on 06/09/2009 (ver.1)
% 

function lms = rgb2lms(rgb, ccmat)

lmsd = ccmat.rgb2lms * rgb;
[m,n]=size(lmsd);
lmsk = repmat(ccmat.lmsk, 1, n);
lms = lmsk + lmsd;






