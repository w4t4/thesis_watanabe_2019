function tonemappedXYZ = wTonemap(xyz,lw,ccmatrix)

[iy,ix,iz] = size(xyz);
mat = zeros(iy,ix,iz);

cx2u = makecform('xyz2upvpl');
cu2x = makecform('upvpl2xyz');
maxUpvpl = applycform(transpose(rgb2XYZ([1 1 1]',ccmatrix)),cx2u);
maxLum = maxUpvpl(3);
upvpl = applycform(xyz,cx2u);
mat = upvpl;
disp(strcat('max luminance: ',num2str(maxLum)));

% Reinhard function
for i = 1:iy
    for j = 1:ix
        x = upvpl(i,j,3)/maxLum;
        mat(i,j,3) = maxLum * x/(1+x)*(1+x/lw^2);
        if mat(i,j,3) > maxLum
            mat(i,j,3) = maxLum;
        elseif mat(i,j,3) < 0
            mat(i,j,3) = 0;
        end
    end
end

tonemappedXYZ = applycform(mat,cu2x);

end