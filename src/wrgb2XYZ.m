function XYZ = wrgb2XYZ(RGB,ccmat)
%
% transfer RGB(x,y,3,0~256,uint8) to xyY3D(x,y,3,double)
% using calibrated data ccmat
% 
% by OKD(use TNtoolbox function:RGBTorgb_LUT,rgb2XYZ)
%


% gamma correction: rgb to RGB(for the monitor)
LUT = load('mat/20191108_w.lut');
rgb = RGBTorgb_LUT(uint16(RGB)*257,LUT);
%rgb = RGB16bit2rgb_LUT(uint16(RGB)*257, LUT);       % size_rgb: (x*y) ✕ 3  (2D)

% convert RGB to xyY
XYZ = rgb2XYZ(rgb', ccmat);                         % size_XYZ: 3 ✕ (x*y)  (2D)
XYZ = XYZ';

end

