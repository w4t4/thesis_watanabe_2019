% wrgb2XYZ
% 
% Calculate XYZ values (0-1) from rgb values (CIE1931 coordinates) 
% without tonemap procedure.
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

function XYZ = wrgb2XYZ(rgb, ccmat)

    [iy,ix,iz] = size(rgb);

    iLUT = load('mat/20191108_w.ilut');
    rgb = uint8(rgb2RGB_iLUT(rgb',iLUT)/257);
    size(rgb)
    
    rgb = reshape(rgb,iy,ix,iz);

    XYZ = rgb2XYZ(rgb,ccmat);
    
    XYZ = reshape(XYZ,[],3)';
    
    
    %imshow(rgb);

end


