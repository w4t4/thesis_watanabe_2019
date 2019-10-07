
SDsame = colorize(maskedData, 1);
SDdifferent = colorize(maskedDiffuse, 1) + colorize(maskedSpecular, 2);
aveBrightness = zeros(1,9);
figure;
montage(xyz2rgb(SDsame)/16, 'size', [1 9]);
figure;
montage(xyz2rgb(SDdifferent)/16, 'size', [1 9]);

ss = strcat('../img/mag',num2str(magnification),'_dl/SDsame',erase(blendFile,'.blend'),'.mat');
sd = strcat('../img/mag',num2str(magnification),'_dl/SDdifferent',erase(blendFile,'.blend'),'.mat');
save(ss,'SDsame');
save(sd,'SDdifferent');

function xyzData = colorize(xyzMaterial, flag)
    cx2u = makecform('xyz2upvpl');
    cu2x = makecform('upvpl2xyz');
    %a = ones([240,320,3]).*150;
    uvlMaterial = applycform(xyzMaterial,cx2u);
    %uvlMaterial = applycform(a,cx2u);
    r2 = sqrt(2);
    uUnitCircle = [0 1 1/r2 0 -1/r2 -1 -1/r2 0 1/r2];
    vUnitCircle = [0 0 1/r2 1 1/r2 0 -1/r2 -1 -1/r2];
    colorDistanceRate = 30;
    for j = 1:9
        r = uvlMaterial;
        if flag == 1
            r(:,:,1) = r(:,:,1) + uUnitCircle(j)/colorDistanceRate;
            r(:,:,2) = r(:,:,2) + vUnitCircle(j)/colorDistanceRate;
        end
        xyz = applycform(r,cu2x);
        for k = 1:3
            if xyz(:,:,k) < 0 | xyz(:,:,k) > 1 | ~isreal(xyz(:,:,k))
                disp("oh....");
                break;
            end
        end
        %meanLuminance(:,:,9*(i-1)+j) = calcMeanLuminance(xyz);
        xyzData(:,:,:,j) = xyz;
    end
end
