% rgb2XYZj (ver1.0)  
% 
% Calculate XYZ values modified by Judd from rgb values.
%
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Usage: 
%    XYZj = rgb2XYZ(rgb, ccmat);
%   
% Input:  
%   rgb:    rgb vector or matrices ([0.8;0.5;0.6] or [0.7,0.4;0.9,0.8;0.7 0.5])
%   ccmat:  color conversion matrix created by makeccmatrix.m
% Output:
%   XYZj:    XYZ vector or matrices
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%
% Created by Takehiro Nagai on 06/09/2009 (ver.1)
% 

function XYZj = rgb2XYZj(rgb, ccmat)

XYZjd = ccmat.rgb2xyzj * rgb;
[m,n]=size(XYZjd);
XYZjk = repmat(ccmat.xyzjk, 1, n);
XYZj = XYZjk + XYZjd;






