
% Dragon or Bunny or Sphere
material = 'Sphere';

magnification = 3;

load(strcat('../img/xyz/xyz',material,'SD.mat'));
load(strcat('../img/xyz/xyz',material,'D.mat'));
load(strcat('../img/xyz/xyz',material,'S.mat'));
load('monitorColorMax.mat');

SDsame = colorize(xyzSD, 1);
SDdifferent = colorize(xyzD, 1) + colorize(xyzS, 0);
aveBrightness = zeros(1,9);
figure;
montage(xyz2rgb(SDsame)/16, 'size', [3 3]);
figure;
montage(xyz2rgb(SDdifferent)/16, 'size', [3 3]);

ss = strcat('../img/mag',num2str(magnification),'/SDsame',material,'.mat');
sd = strcat('../img/mag',num2str(magnification),'/SDdifferent',material,'.mat');
save(ss,'SDsame');
save(sd,'SDdifferent');

function xyzData = colorize(xyzMaterial, isIncludeDiff)
    cx2u = makecform('xyz2upvpl');
    cu2x = makecform('upvpl2xyz');
    uvlMaterial = applycform(xyzMaterial,cx2u);
    for j = 1:9
        r = uvlMaterial;
        if isIncludeDiff == 1
            r(:,:,1) = r(:,:,1) + uUnitCircle(j)/colorDistanceRate;
            r(:,:,2) = r(:,:,2) + vUnitCircle(j)/colorDistanceRate;
        end
        xyz = applycform(r,cu2x);
        
        xyzData(:,:,:,j) = xyz;
    end
end
