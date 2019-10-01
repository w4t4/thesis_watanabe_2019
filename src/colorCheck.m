load('ccmatrix.mat');
load('../img/mag1_dl/SDsameSphere.mat');
[ix,iy,iz] = size(SDsame(:,:,:,1));
po = zeros(ix,iy,iz);
count = 0;
maxp = 0;

for i = 1:ix
    for j = 1:iy
        for k = 1:iz
            for l = 1:3
                po(i,j,k) = po(i,j,k) + ccmatrix.xyz2rgb(k,l) * outputXYZCalFormat(i,j,l);
            end
            if po(i,j,k) > 1
%                po(i,j,k) = 1;
            end
        end
        if maxp < min(po(i,j))
            maxp = min(po(i,j));
        end
        if max(po(i,j)) < 0.001;
            count = count + 1;
        end
    end
end
po = po / maxp;
figure;
imshow(po);
count
maxp
%figure;
%imshow(xyz2rgb(SDsame(:,:,:,1))/16);