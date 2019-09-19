% xyzData, xyzMask
% xyzMask: dragon -> 0

% x>0 -> 1, x=0 -> 0  
binarizedx = xyzMask(:,:,1) > 0;
binarized = repmat(binarizedx, [1 1 3]);
maskedData = xyzData .* (1-binarized);
maskedSpecular = xyzSpecular .* (1-binarized);
maskedDiffuse = xyzDiffuse .* (1-binarized);

% show non-colorized Material
montage([xyz2rgb(maskedData)/16, xyz2rgb(maskedSpecular)/16, xyz2rgb(maskedDiffuse)/16, xyz2rgb(maskedSpecular+maskedDiffuse)/16],'size',[1 1]);