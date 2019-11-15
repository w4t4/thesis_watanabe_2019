
% Dragon or Bunny or Sphere
material = 'Sphere';

magnification = 3;

load(strcat('../img/xyz/xyz',material,'SD.mat'));
load(strcat('../img/xyz/xyz',material,'D.mat'));
load(strcat('../img/xyz/xyz',material,'S.mat'));
load('mat/monitorColorMax.mat');
load('mat/logScale.mat');


SDsame = colorizeXYZ(wTonemap(xyzSD,1.3,0.95,ccmat));
SDdifferent = colorizeXYZ(wTonemapDiff(xyzD,xyzSD,2,0.45,ccmat)) + wTonemapDiff(xyzS,xyzSD,1,0.9,ccmat);
aveBrightness = zeros(1,9);
for i = 1:9
    figure;
    wImageXYZ2rgb_wtm(SDsame(:,:,:,i),ccmat);
    figure;
    wImageXYZ2rgb_wtm(SDdifferent(:,:,:,i),ccmat);
end
cx2u = makecform('xyz2upvpl');
po = applycform(SDsame(:,:,:,1),cx2u);
same = max(max(po))
pyon = applycform(SDdifferent(:,:,:,1),cx2u);
diff = max(max(pyon))

ss = strcat('../img/mag',num2str(magnification),'/SDsame',material,'.mat');
sd = strcat('../img/mag',num2str(magnification),'/SDdifferent',material,'.mat');
save(ss,'SDsame');
save(sd,'SDdifferent');

function coloredXyzData = colorizeXYZ(xyzMaterial)
    cx2u = makecform('xyz2upvpl');
    cu2x = makecform('upvpl2xyz');
    upvplMaterial = applycform(xyzMaterial,cx2u);
    [iy,ix,iz] = size(xyzMaterial);
    coloredXyzData = zeros(iy,ix,iz,9);
    coloredXyzData(:,:,:,1) = xyzMaterial;
    load('mat/monitorColorMax.mat');
    load('mat/upvplWhitePoints.mat');
    weight = 0.5;
 
   
    for i = 1:9
        upvpl = upvplMaterial;
        for j = 1:iy
            for k = 1:ix
                for l = 1:size(monitorColorMax,1)-1
                    if upvpl(j,k,3) > monitorColorMax(l,3,1) && upvplMaterial(j,k,3) < monitorColorMax(l+1,3,1)
                        if i == 1
                            upvpl(j,k,1) = upvplWhitePoints(l,1);
                            upvpl(j,k,2) = upvplWhitePoints(l,2);
                        else
                            upvpl(j,k,1) = monitorColorMax(l,1,i-1)*weight+upvplWhitePoints(l,1)*(1-weight);
                            upvpl(j,k,2) = monitorColorMax(l,2,i-1)*weight+upvplWhitePoints(l,2)*(1-weight);
                        end
                    end
                end
            end
        end
        disp(i);
        coloredXyzData(:,:,:,i) = applycform(upvpl,cu2x);
    end
end
