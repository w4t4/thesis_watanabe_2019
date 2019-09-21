load('ccmatrix.mat');
load('../img/mag1_0.4/SDsameDragon.mat');
[ix,iy,iz] = size(SDsame(:,:,:,1));
permuted = permute(SDsame(:,:,:,2),[3 1 2]);
reshaped = reshape(permuted,3,ix*iy);
rgb = ccmatrix.xyz2rgb * reshaped;
reshaped2 = reshape(rgb,3,ix,iy);
permuted2 = permute(reshaped2,[2 3 1]);
imshow(permuted2);