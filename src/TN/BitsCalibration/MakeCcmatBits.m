% MakeCcmatBits.m ver1.0
%
% Make ccmat file (color conversion file) using ColorCAL calibration data
% measured in ColorCALBitsPTB3.m.
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Usage: 
%    ccmat = MakeCcmatBits(xyY);
% 
% Input:
%    XYZ:   measured XYZ matrix.
%
% Output:
%    ccmat: Color Conversion Matrix (though this is imcomplete compared to spectral measurement)
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Created by Takehiro Nagai on May 7th 2010

function ccmat = MakeCcmatBits(XYZ)

XYZm = zeros(3,3);
l = size(XYZ, 3);
for a=1:3
    for b=1:3
        XYZm(a,b) = mean(XYZ(a, b, :));
    end
end

ccmat.xyzk = [mean(XYZ(4, 1, :)); mean(XYZ(4, 2, :)); mean(XYZ(4, 3, :))];
ccmat.rgb2xyz = XYZm'-repmat(ccmat.xyzk, 1,3);
ccmat.xyz2rgb = inv(ccmat.rgb2xyz);
