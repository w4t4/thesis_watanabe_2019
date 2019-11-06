% wImageXYZ2rgb
% 
% Calculate XYZ values (0-1) from rgb values (CIE1931 coordinates) 
% including tonemap procedure.
%
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Usage: 
%    rgb = XYZ2rgb(XYZ, ccmat);
%   
% Input:  
%   XYZ(image): [iy ix 3]
%   lw: parameter of Reinhard function
%   ccmat:  color conversion matrix created by makeccmatrix.m
%
% Output:
%   rgb:    rgb vector or matrices
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 

function rgb = wImageXYZ2rgb(XYZ, lw, ccmatrix)

    XYZ = wTonemap(XYZ,lw,ccmatrix);

    [iy,ix,iz]=size(XYZ);
    XYZ = w3dto2d(XYZ);

    XYZk = repmat(ccmatrix.xyzk, 1, ix*iy);
    XYZd = XYZ-XYZk;
    
    rgb = ccmatrix.xyz2rgb * XYZd;
    rgb = w2dto3d(rgb,ix,iy,iz);
    
    imshow(rgb);

end



