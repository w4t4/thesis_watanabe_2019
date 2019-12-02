
load('../img/mag3/SDdifferentDragon.mat');
mc = zeros(3,9,2);
luminance = zeros(2,9);
for i = 1:9
    load('../img/mag3/SDsameDragon.mat');
    mc(:,i,1) = calcMeanColor(SDsame(:,:,:,i));
    luminance(1,i) = getLuminance(transpose(mc(:,i)));
end
for i = 1:9
    mc(:,i,2) = calcMeanColor(SDdifferent(:,:,:,i));
    luminance(2,i) = getLuminance(transpose(mc(:,i)));
end
save('mat/mc.mat', 'mc');
save('mat/luminance.mat', 'luminance');

function meanColor = calcMeanColor(xyz)
    [iy,ix,iz] = size(xyz);
    meanColor = zeros(1,3);
    cx2u = makecform('xyz2upvpl');
    cu2x = makecform('upvpl2xyz');
    uvl = applycform(xyz,cx2u);
    for i = 1:iz
        notZeroCount = 0;
        sum = 0;
        for j = 1:ix
            for k = 1:iy
                if (xyz(k,j,i) ~= 0)
                    notZeroCount = notZeroCount + 1;
                    sum = sum + uvl(k,j,i);
                end
            end
        end
        meanColor(i) = sum / notZeroCount;
    end
    meanColor = applycform(meanColor,cu2x)
end

function l = getLuminance(xyz)
    C = makecform('xyz2xyl');
    xyl = applycform(xyz,C);
    l = xyl(3);
end