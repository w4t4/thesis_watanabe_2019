function tonemappedXYZ = wTonemap(xyz,lw,ccmatrix)

[iy,ix,iz] = size(xyz);

cx2u = makecform('xyz2upvpl');
cu2x = makecform('upvpl2xyz');
maxUpvpl = applycform(transpose(rgb2XYZ([1 1 1]',ccmatrix)),cx2u);
maxLum = maxUpvpl(3);
upvpl = applycform(xyz,cx2u);
disp(strcat('max luminance: ',num2str(maxLum)));
a = max(max(upvpl));
sh = 8;

% Reinhard function
for i = 1:iy
    for j = 1:ix
        x = upvpl(i,j,3)/a(3);
        %upvpl(i,j,3) = maxLum * x*sh/(1+x*sh)*(1+x*sh/lw^2);
        %upvpl(i,j,3) = maxLum * x.^(1/lw);
        upvpl(i,j,3) = maxLum * log(1+lw*x);
        if upvpl(i,j,3) > maxLum
            upvpl(i,j,3) = maxLum;
        elseif upvpl(i,j,3) < 0
            upvpl(i,j,3) = 0;
        end
    end
end

tonemappedXYZ = applycform(upvpl,cu2x);

end
