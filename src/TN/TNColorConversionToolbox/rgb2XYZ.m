% XYZ2Yxy (ver1.0)  
% 
% Calculate rgb values from XYZ values (CIE1931 coordinates).
%
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Usage: 
%    XYZ = rgb2XYZ(rgb, ccmat);
%   
% Input:  
%   rgb:    rgb vector or matrices ([0.8;0.5;0.6] or [0.7,0.4;0.9,0.8;0.7 0.5])
%   ccmat:  color conversion matrix created by makeccmatrix.m
% Output:
%   XYZ:    XYZ vector or matrices
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%
% Created by Takehiro Nagai on 06/09/2009 (ver.1)
% 

function XYZ = rgb2XYZ(rgb, ccmat)

XYZd = ccmat.rgb2xyz * rgb;
[m,n]=size(XYZd);
XYZk = repmat(ccmat.xyzk, 1, n);
XYZ = XYZk + XYZd;






