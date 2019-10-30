% rgb2RGB_fitting (ver1.0)  
% 
% Compute RGB digital values of Bits++ output (0~65535) corresponding to 
% desired CRT's RGB intensity(0~1) by fitted inverse gamma function.
%
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Usage: 
%   RGB = rgb2RGB_fitting(rgb, para);
%   
% Input:  
%   rgb:  rgb(0~1) matrix, ([0.1 0.2 0.5] or [0.2 0.3 0.4;  0.3 0.4 0.5])
%   para: Calibration data, which could be read from '.ilp' file.
%         '.ilp' file could be created by 'udtmeasPTB3_menu.m' or 'fitint2voltBits.m'
%
% Output:
%   RGB:  RGB (0~65535) matrix.
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%
% Created by Takehiro Nagai on 07/02/2007 (ver.1)
%

function RGB=rgb2RGB_fitting(rgb,para)

rgbsize = size(rgb);

RGB = zeros(rgbsize(1),3);
for gun = 1:3
   RGB(:,gun) = round(gammacinv(rgb(:,gun),para).*65535);
   for i=1:rgbsize(1)
        if rgb(i,gun)==0; RGB(i,gun)=0; end;
   end
end

