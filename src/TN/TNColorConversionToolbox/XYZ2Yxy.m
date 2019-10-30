% XYZ2Yxy (ver1.0)  
% 
% Calculate Yxy values from XYZ values (CIE1931 coordinates).
%
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Usage: 
%    Yxy = XYZ2Yxy(XYZ);
%   
% Input:  
%   XYZ:    XYZ vector or matrices ([20;19;32] or [23 20;18 14;21 24])
%
% Output:
%   Yxy:    Yxy vector or matrices
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%
% Created by Takehiro Nagai on 06/09/2009 (ver.1)
% 

function Yxy = XYZ2Yxy(XYZ)

[m,n] = size(XYZ);
Yxy = zeros(m,n);
s = sum(XYZ,1);

Yxy(1,:) = XYZ(2,:);
Yxy(2,:) = XYZ(1,:)./s(:);
Yxy(3,:) = XYZ(2,:)./s(:);






