function maxp = wtColorCheck(rgb)
    [iy,ix,iz] = size(rgb);
    maxp = 0;
    minp = 1000;

    for i = 1:iy
        for j = 1:ix
            if maxp < max(rgb(i,j))
                maxp = max(rgb(i,j));
            end
            if minp > min(rgb(i,j))
                minp = min(rgb(i,j));
            end
        end
    end
    maxp
end

