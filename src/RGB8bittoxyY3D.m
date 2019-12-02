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


    function xyY = XYZ2xyY(XYZ)
    % from TN toolbox function Yxy = XYZ2Yxy(XYZ);
    % 
    % modified by OKD on 2019/11/02
    % array Yxy to xyY
    %
    [m,n] = size(XYZ);
    xyY = zeros(m,n);
    s = sum(XYZ,1);

    xyY(3,:) = XYZ(2,:);
    xyY(1,:) = XYZ(1,:)./s;%Yxy(2,:) = XYZ(1,:)./s(:); arranged by OKD
    xyY(2,:) = XYZ(2,:)./s;%Yxy(3,:) = XYZ(2,:)./s(:); arranged by OKD
    end

    function rgb=RGB16bit2rgb_LUT(RGB, LUT)
    % RGB2rgb_LUT (ver1.0)  
    % 
    % Compute RGB digital values of Bits++ output (0~65535) corresponding to 
    % desired CRT's RGB intensity(0~1) by inverse look up table.
    %
    %
    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Usage: 
    %   rgb = RGB2rgb_LUT(RGB, LUT);
    %   
    % Input:  
    %   RGB:  RGB (0~65535) matrix.
    %   LUT: Calibration data, which could be read from '.lut' file.
    %         '.lut' file could be created by 'udtmeasPTB3_menu.m' or 'fitint2voltBits.m'
    %
    % Output:
    %   rgb:  rgb(0~1) matrix, ([0.1 0.2 0.5] or [0.2 0.3 0.4;  0.3 0.4 0.5])
    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %
    % Created by Takehiro Nagai on 07/02/2007 (ver.1)
    % 

    RGBsize = size(RGB);
    rgb = zeros(RGBsize(1),3);

    for gun = 1:3
       rgb(:,gun) = LUT(RGB(:,gun)+1,gun);
    end

    end

end

%{
%for value check

size_RGB = size(RGB)
size_rgb = size(rgb)
size_XYZ = size(XYZ)
size_xyY = size(xyY)
xy


disp(RGB(1000000:1000010,:)');
disp(rgb(1000000:1000010,:)');

disp(XYZ(:,1000000:1000010));
disp(xyY(:,1000000:1000010));

min(min(xyY(3,:)))
max(max(xyY(3,:)))
%}