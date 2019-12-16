function r = getCorrelationEfficient(x,y)
    [l,c] = size(x);
    sxy = 0;
    sx = 0;
    sy = 0;
    for i = 1:c
        tx = x(i) - mean(x);
        ty = y(i) - mean(y);
        sxy = sxy + tx*ty;
        sx = sx + tx^2;
        sy = sy + ty^2;
    end
    r = sxy / sqrt(sx*sy);
end   