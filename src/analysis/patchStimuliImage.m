a = ones(200,200,3,18);
for i = 1:9
    for j = 1:2
        for k = 1:3
            a(:,:,k,9*(j-1)+i) = a(:,:,k,9*(j-1)+i) * mc(k,i,j);
        end
    end
end
montage(a/255,'size',[2 9])