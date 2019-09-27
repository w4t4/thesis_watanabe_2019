load('ccmatrix.mat');
load('../img/mag3_dl/SDsameDragon.mat');
[ix,iy,iz] = size(SDsame(:,:,:,1));
po = zeros(ix,iy,iz);
for i = 1:ix
    for j = 1:iy
        for k = 1:iz
            for l = 1:3
                po(i,j,k) = po(i,j,k) + ccmatrix.xyz2rgb(k,l) * SDsame(i,j,l,1) / 3;
            end
            if po(i,j,k) > 1
                po(i,j,k) = 1;
            end
        end
    end
end
for m = 1:3
    %po(:,:,m) = po(:,:,m) / max(max(max(po)));
end
figure;
imshow(po);
%figure;
%imshow(xyz2rgb(SDsame(:,:,:,1))/16);