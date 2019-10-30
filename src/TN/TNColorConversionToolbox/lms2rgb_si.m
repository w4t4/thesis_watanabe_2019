% lms2rgb_si (ver1.0)  
% 
% Calculate rgb values (0-1) from lms values cosidering subjective isoluminance based on RGB values.
%
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Usage: 
%    rgb = lms2rgb_si(lmsj, ccmat, RGBKp, RGBs);
%   
% Input:  
%   lms:    lms vector or matrices ([20;26;15] or [24,27;34,18;29 42])
%   ccmat:  color conversion matrix created by makeccmatrix.m
%
% Output:
%   rgb:    rgb vector or matrices
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%
% Created by Takehiro Nagai on 09/30/2009 (ver.1)
% 


function rgb = lms2rgb_si(lms, ccmat, RGBKp, RGBs)

[n,m] = size(lms);
rgbt = lms2rgb(lms, ccmat);

lmst = [];
for i=1:m
    Lp = sum(RGBKp(1:3).*rgbt(:,i)) + RGBKp(4);  % physical luminance index
    Ls = sum(RGBs(1:3).*rgbt(:,i)) + RGBKp(4);  % subjective luminance index
    lmst = [lmst lms(:,i).* (Lp/Ls)];
end


rgb = lms2rgb(lmst, ccmat);


