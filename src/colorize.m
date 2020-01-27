
% Dragon or Bunny
material = 'Dragon';

magnification = 3;

load(strcat('../img/xyz/xyz',material,'SD.mat'));
load(strcat('../img/xyz/xyz',material,'D.mat'));
load(strcat('../img/xyz/xyz',material,'S.mat'));
load('mat/ccmat.mat');
load('mat/monitorColorMax.mat');
load('mat/logScale.mat');

scale = 0.4;
SDsame = colorizeXYZ(wTonemapDiff(xyzS,xyzSD,1,scale,ccmat)) + colorizeXYZ(wTonemapDiff(xyzD,xyzSD,1,scale,ccmat));
SDdifferent = colorizeXYZ(wTonemapDiff(xyzD,xyzSD,1,scale,ccmat)) + wTonemapDiff(xyzS,xyzSD,1,scale,ccmat);
aveBrightness = zeros(1,9);
for i = 1:9
    %figure;
    wImageXYZ2rgb_wtm(SDsame(:,:,:,i),ccmat);
    %figure;
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
    load('mat/fixedColorMax.mat');
    load('mat/upvplWhitePoints.mat');
    weight = ones(2,8);
    saturateMax = fixedColorMax;
    % 0.087 ~ 0.34
    m = zeros(2,8);
    for i = 1:2
        for j = 1:8
            m = max(abs(fixedColorMax(:,i,j)));
            if m ~= 0
                %0.13
                saturateMax(:,i,j) = fixedColorMax(:,i,j)/m*0.09;
            end
        end
    end
    %saturateMax
 
    for i = 1:9
        upvpl = upvplMaterial;
        for j = 1:iy
            for k = 1:ix
                for l = 1:size(fixedColorMax,1)-1
                    if upvpl(j,k,3) > fixedColorMax(l,3,1) && upvplMaterial(j,k,3) < fixedColorMax(l+1,3,1)
                        if i == 1
                            upvpl(j,k,1) = upvplWhitePoints(l,1);
                            upvpl(j,k,2) = upvplWhitePoints(l,2);
                        else
                            if max(abs(fixedColorMax(:,1,i-1))) < max(abs(saturateMax(:,1,i-1)))
                                upvpl(j,k,1) = fixedColorMax(l,1,i-1)+upvplWhitePoints(l,1);
                                upvpl(j,k,2) = fixedColorMax(l,2,i-1)+upvplWhitePoints(l,2);
                            else
                                upvpl(j,k,1) = saturateMax(l,1,i-1)+upvplWhitePoints(l,1);
                                upvpl(j,k,2) = saturateMax(l,2,i-1)+upvplWhitePoints(l,2);
                            end
                        end
                    end
                end
            end
        end
        disp(i);
        coloredXyzData(:,:,:,i) = applycform(upvpl,cu2x);
    end
end
