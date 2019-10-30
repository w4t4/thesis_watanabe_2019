% Yxy2XYZ (ver1.0)  
% 
% Calculate XYZ values from Yxy values (CIE1931 coordinates).
%
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Usage: 
%    XYZ = Yxy2XYZ(Yxy);
%   
% Input:  
%   Yxy:    Yxy vector or matrices ([20;0.333;0.321] or [20 14;0.333 0.243;0.333 0.421])
%
% Output:
%   XYZ:    XYZ vector or matrices
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%
% Created by Takehiro Nagai on 06/09/2009 (ver.1)
% 

function XYZ = Yxy2XYZ(Yxy)

[m,n] = size(Yxy);
XYZ = zeros(m,n);
for i = 1:n
  z = 1 - Yxy(2,i) - Yxy(3,i);
  XYZ(1,i) = Yxy(1,i)*Yxy(2,i)/Yxy(3,i);
  XYZ(2,i) = Yxy(1,i);
  XYZ(3,i) = Yxy(1,i)*z/Yxy(3,i);
end





