
load('../img/dragon/Dsame.mat');
load('../img/dragon/Ddiff.mat');
mc = zeros(3,9,2);
luminance = zeros(2,9);
for i = 1:9
    mc(:,i,1) = calcMeanColor(Dsame(:,:,:,i));
    luminance(1,i) = getLuminance(transpose(mc(:,i)),ccmat);
end
for i = 1:9
    mc(:,i,2) = calcMeanColor(Ddiff(:,:,:,i));
    luminance(2,i) = getLuminance(transpose(mc(:,i)),ccmat);
end
save('mat/mc.mat', 'mc');
save('mat/luminance.mat', 'luminance');

function meanColorRGB = calcMeanColor(rgb)
    [iy,ix,iz] = size(rgb);
    meanColorRGB = zeros(1,3);
    %cx2u = makecform('xyz2upvpl');
    %cu2x = makecform('upvpl2xyz');
    %uvl = applycform(xyz,cx2u);
    notZeroCount = 0;
    sum = zeros(1,1,3);
    for j = 1:ix
        for k = 1:iy
            if (max(rgb(k,j,:)) >= 25)
                notZeroCount = notZeroCount + 1;
                sum = sum + rgb(k,j,:);
            end
        end
    end
    disp(notZeroCount)
    meanColorRGB = sum / notZeroCount;
end

function l = getLuminance(rgb,ccmat)
    C = makecform('xyz2xyl');
    xyz = wrgb2XYZ(rgb,ccmat);
    xyl = applycform(xyz,C);
    l = xyl(3);
end