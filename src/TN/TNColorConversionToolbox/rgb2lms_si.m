% rgb2lms_si (ver1.0)  
% 
% Calculate lms values from rgb values.
%
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Usage: 
%    lms = rgb2lms_si(rgb, ccmat, RGBKp, RGBs);
%   
% Input:  
%   rgb:    rgb vector or matrices ([0.8;0.5;0.6] or [0.7,0.4;0.9,0.8;0.7 0.5])
%   ccmat:  color conversion matrix created by makeccmatrix.m
% Output:
%   lms:    lms vector or matrices
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%
% Created by Takehiro Nagai on 09/30/2009 (ver.1)
% 

function lms = rgb2lms_si(rgb, ccmat, RGBKp, RGBs)

lmsd = ccmat.rgb2lms * rgb;
[m,n]=size(lmsd);
lmsk = repmat(ccmat.lmsk, 1, n);
lmst = lmsk + lmsd;

lms=[];
for i=1:n
    Lp = sum(RGBKp(1:3).*rgb(:,i)) + RGBKp(4);  % physical luminance index
    Ls = sum(RGBs(1:3).*rgb(:,i)) + RGBKp(4);  % subjective luminance index
    lms = [lms lmst(:,i).* (Ls/Lp)];
end






