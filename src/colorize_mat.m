
SDsame = colorize(maskedData, 1);
SDdifferent = colorize(maskedDiffuse, 1) + colorize(maskedSpecular, 2);
aveBrightness = zeros(3,9);
figure;
montage(xyz2rgb(SDsame)/16, 'size', [3 9]);
figure;
montage(xyz2rgb(SDdifferent)/16, 'size', [3 9]);
save('SDsameBunny.mat','SDsame');
save('SDdifferentBunny.mat','SDdifferent');

function xyzData = colorize(xyzMaterial, flag)
    cx2u = makecform('xyz2upvpl');
    cu2x = makecform('upvpl2xyz');
    %a = ones([240,320,3]).*150;
    uvlMaterial = applycform(xyzMaterial,cx2u);
    %uvlMaterial = applycform(a,cx2u);
    r2 = sqrt(2);
    uUnitCircle = [0 1 1/r2 0 -1/r2 -1 -1/r2 0 1/r2];
    vUnitCircle = [0 0 1/r2 1 1/r2 0 -1/r2 -1 -1/r2];
    luminance = [1 0.25 0.0625];
    colorDistanceRate = 35;
    for i = 1:3
        for j = 1:9
            r = uvlMaterial;
            if flag == 1
                r(:,:,1) = r(:,:,1) + uUnitCircle(j)/colorDistanceRate;
                r(:,:,2) = r(:,:,2) + vUnitCircle(j)/colorDistanceRate;
            end
            r(:,:,3) = r(:,:,3) .* luminance(i);
            xyz = applycform(r,cu2x);
            for k = 1:3
                if xyz(120,120,k) < 0
                    disp("oh....");
                end
            end
            %meanLuminance(:,:,9*(i-1)+j) = calcMeanLuminance(xyz);
            xyzData(:,:,:,9*(i-1)+j) = xyz;
        end
    end
end
