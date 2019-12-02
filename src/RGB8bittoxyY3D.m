function xyY3D = RGB8bittoxyY3D(RGB,ccmat,LUT)
%
% transfer RGB(x,y,3,0~256,uint8) to xyY3D(x,y,3,double)
% using calibrated data ccmat
% 
% by OKD(use TNtoolbox function:RGBTorgb_LUT,rgb2XYZ)
%


% get the image-size(x,y)
xy=size(RGB(:,:,1));

% convert xyY to RGB
RGB = reshape(RGB,[],3);                            % size_RGB: (x*y) ✕ 3  (2D)

% gamma correction: rgb to RGB(for the monitor)
rgb = RGBTorgb_LUT(uint16(RGB)*257,LUT);
%rgb = RGB16bit2rgb_LUT(uint16(RGB)*257, LUT);       % size_rgb: (x*y) ✕ 3  (2D)


% convert RGB to xyY
XYZ = rgb2XYZ(rgb', ccmat);                         % size_XYZ: 3 ✕ (x*y)  (2D)

% see the details below function:function xyY = XYZ2xyY(XYZ)
xyY = XYZ2xyY(XYZ);                                 % size_xyY: 3 ✕ (x*y)  (2D)

% array reshape 3✕(x*y) to x,y,3(xyY)
xyY3D=xyY';
xyY3D=reshape(xyY3D,xy(1),xy(2),3);                 % size_xyY3D: x ✕ y ✕ 3  (3D)

