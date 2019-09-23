% 
%a = ones([240,320,3]).*150;
[ix,iy,iz] = size(maskedData);
permutedXyzMaterial = permute(maskedData,[3 1 2]);
reshapedXyzMaterial = reshape(permutedXyzMaterial,3,ix*iy);
uvlMaterial = XYZTouvY(reshapedXyzMaterial);
%uvlMaterial = applycform(a,cx2u);
r2 = sqrt(2);
uUnitCircle = [0 1 1/r2 0 -1/r2 -1 -1/r2 0 1/r2];
vUnitCircle = [0 0 1/r2 1 1/r2 0 -1/r2 -1 -1/r2];
luminance = [1 0.4 0.16];
colorDistanceRate = 9;
for i = 1:3
    for j = 1:9
        r = uvlMaterial;
        r(1,:) = r(1,:) + uUnitCircle(j)/colorDistanceRate;
        r(2,:) = r(2,:) + vUnitCircle(j)/colorDistanceRate;
        r(3,:) = r(3,:) .* luminance(i);
        xyzColored = uvYToXYZ(r);
        reshapedXyzColored = reshape(xyzColored,3,ix,iy);
        permutedXyzColored = permute(reshapedXyzColored,[2 3 1]);
        xyzData(:,:,:,9*(i-1)+j) = permutedXyzColored;
    end
end
figure;
montage(rgb2xyz(xyzData)/16,'size',[3 9]);