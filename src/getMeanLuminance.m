load('../img/mag1_0.4/SDsameDragon.mat');
load('../img/mag1/SDdifferentDragon.mat');
SDsameDragon = SDsame;
SDdifferentDragon = SDdifferent;
%load('../img/mag1/SDsameBunny.mat');
%load('../img/mag1/SDdifferentBunny.mat');
%SDsameBunny = SDsame;
%SDdifferentBunny = SDdifferent;
%load('../img/mag1/SDsameSphere.mat
%load('../img/mag1/SDdifferentSphere.mat');
%SDsameSphere = SDsame;
%SDdifferentSphere= SDdifferent;
ml = zeros(3,27);
luminance = zeros(3,9);
for i = 1:27
    ml(:,i) = calcMeanLuminance(SDsameDragon(:,:,:,i));
    luminance(floor((i-1)/9) + 1,mod(i,9) + 1) = getLuminance(transpose(ml(:,i)));
end
save('ml.mat', 'ml');
save('luminance.mat', 'luminance');

function meanLuminance = calcMeanLuminance(xyz)
    [iy,ix,iz] = size(xyz);
    meanLuminance = zeros(1,3);
    for i = 1:iz
        notZeroCount = 0;
        sum = 0;
        for j = 1:ix
            for k = 1:iy
                if (xyz(k,j,i) ~= 0)
                    notZeroCount = notZeroCount + 1;
                    sum = sum + xyz(k,j,i);
                end
            end
        end
        meanLuminance(i) = sum / notZeroCount;
    end
end

function l = getLuminance(xyz)
    C = makecform('xyz2xyl');
    xyl = applycform(xyz,C);
    l = xyl(3);
end