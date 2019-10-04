% XYZ2rgb (ver1.0)  
% 
% Calculate rgb values (0-1) from XYZ values (CIE1931 coordinates).
%
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Usage: 
%    rgb = XYZ2rgb(XYZ, ccmat);
%   
% Input:  
%   XYZ:    XYZ vector or matrices ([20;26;15] or [24,27;34,18;29 42])
%   ccmat:  color conversion matrix created by makeccmatrix.m
%
% Output:
%   rgb:    rgb vector or matrices
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%
% Created by Takehiro Nagai on 06/09/2009 (ver.1)
% 

%function rgb = XYZ2rgb(XYZ, ccmatrix)
XYZ = Dsame(:,:,:,1);

[iy,ix,iz]=size(XYZ);
XYZ = wt3dto2d(XYZ);

XYZk = repmat(ccmatrix.xyzk, 1, ix*iy);
XYZd = XYZ-XYZk;

rgb = ccmatrix.xyz2rgb * XYZd;
rgb = wt2dto3d(rgb,ix,iy,iz);
imshow(rgb);




