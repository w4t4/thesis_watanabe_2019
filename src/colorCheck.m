load('ccmatrix.mat');
load('../img/mag1_0.4/SDsameDragon.mat');
[ix,iy,iz] = size(SDsame(:,:,:,1));
permuted = permute(SDsame(:,:,:,9),[3 2 1]);
reshaped = reshape(permuted,[3,ix*iy]);
rgb = ccmatrix.xyz2rgb * reshaped * 256;
maxLuminance = zeros(3,1);
for i = 1:3
    for j = ix * iy
        if maxLuminance(i,1) < rgb(i,j)
            maxLuminance(i,1) = rgb(i,j);
        end
    end 
end
reshaped2 = reshape(rgb,3,iy,ix);
permuted2 = permute(reshaped2,[3 2 1]);
figure;
imshow(permuted2);
figure;
imshow(xyz2rgb(SDsame(:,:,:,1))/16);