function rgb = Calxyz2rgb(xyz)
    load('ccmatrix.mat');
    [ix,iy,iz] = size(xyz);
    po = zeros(ix,iy,iz);
    count = 0;
    maxp = 0;

    a = xyz;
    maxLum = 300;
    permuted = permute(a,[3 2 1]);
    reshaped = reshape(permuted,[iz,iy*ix]);
    b = BasicToneMapCalFormat(reshaped,maxLum);
    reshaped2 = reshape(b,[iz iy ix]);
    permuted2 = permute(reshaped2,[3 2 1]);


    for i = 1:ix
        for j = 1:iy
            for k = 1:iz
                for l = 1:3
                    po(i,j,k) = po(i,j,k) + ccmatrix.xyz2rgb(k,l) * permuted2(i,j,k);
                end
                if po(i,j,k) > 1
    %                po(i,j,k) = 1;
                end
            end
            if maxp < max(po(i,j))
                maxp = max(po(i,j));
            end
        end
    end
    maxp
    po = po / maxp;
    rgb = po;
    %imshow(rgb);
end

