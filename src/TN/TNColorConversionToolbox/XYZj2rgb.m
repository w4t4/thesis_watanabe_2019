% XYZj2rgb (ver1.0)  
% 
% Calculate rgb values (0-1) from XYZ values modified by Judd.
%
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Usage: 
%    rgb = XYZj2rgb(XYZj, ccmat);
%   
% Input:  
%   XYZj:    XYZj vector or matrices ([20;26;15] or [24,27;34,18;29 42])
%   ccmat:  color conversion matrix created by makeccmatrix.m
%
% Output:
%   rgb:    rgb vector or matrices
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%
% Created by Takehiro Nagai on 06/09/2009 (ver.1)
% 

function rgb = XYZj2rgb(XYZj, ccmat)

[m,n]=size(XYZj);

XYZjk = repmat(ccmat.xyzjk, 1, n);
XYZjd = XYZj-XYZjk;

rgb = ccmat.xyzj2rgb * XYZjd;






