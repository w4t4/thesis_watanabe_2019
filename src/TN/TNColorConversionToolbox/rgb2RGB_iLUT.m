% rgb2RGB_iLUT (ver1.0)  
% 
% Compute RGB digital values of Bits++ output (0~65535) corresponding to 
% desired CRT's RGB intensity(0~1) by inverse look up table.
%
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Usage: 
%   RGB = rgb2RGB_iLUT(rgb, iLUT);
%   
% Input:  
%   rgb:  rgb(0~1) matrix, ([0.1 0.2 0.5] or [0.2 0.3 0.4;  0.3 0.4 0.5])
%   iLUT: Calibration data, which could be read from '.ilut' file.
%         '.ilut' file could be created by 'udtmeasPTB3_menu.m' or 'fitint2voltBits.m'
%
% Output:
%   RGB:  RGB (0~65535) matrix.
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%
% Created by Takehiro Nagai on 07/02/2007 (ver.1)
% 

function RGB=rgb2RGB_iLUT(rgb, iLUT)

rgbint = round(rgb.*65535)+1;
rgbsize = size(rgbint);

RGB = zeros(rgbsize(1),3);
for gun = 1:3
   RGB(:,gun) = iLUT(rgbint(:,gun),gun);
end
