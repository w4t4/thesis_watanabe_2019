% rgb2RGB_LUT (ver1.1)  
% 
% Compute RGB digital values of Bits++ output (0~65535) corresponding to 
% desired CRT's RGB intensity(0~1) by look up table.
%
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Usage: 
%   RGB = rgb2RGB_LUT(rgb, gamma);
%   
% Input:  
%   rgb:   rgb(0~1) matrix, ([0.1 0.2 0.5] or [0.2 0.3 0.4;  0.3 0.4 0.5])
%   gamma: Calibration data, which could be read from '.lut' file.
%          '.lut' file could be created by 'udtmeasPTB3_menu.m' or 'fitint2voltBits.m'
%
% Output:
%   RGB:  RGB (0~65535) matrix.
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%
% Created by Takehiro Nagai on 07/02/2007 (ver.1)
% Modified by Takehiro Nagai on 07/03/2007 (ver.1.1: speed up)


function y=rgb2RGB_LUT(rgb,gamma)

% size of data matrix
rgbsz=size(rgb);

y = ones(rgbsz(1),rgbsz(2));

for a=1:3	% rgb gun
	for b=1:rgbsz(1)	% each data in rgb
		index=32768;
		comparison=32768;
        
        for i=1:15	% search for a level that could generate closest luminance to desired one
            if rgb(b,a) > gamma(comparison,a);  
                comparison=comparison+index./2;
            else
                comparison=comparison-index./2;
            end;
            index = index./2;
        end;
        
        if abs(rgb(b,a)-gamma(comparison,a)) > abs(rgb(b,a)-gamma(comparison+1,a))  % conclusion
            y(b,a)=(comparison+1)-1;
        else
            y(b,a)=(comparison)-1;
        end
	end
end