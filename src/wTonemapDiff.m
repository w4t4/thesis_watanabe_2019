function tonemappedXYZ = wTonemapDiff(xyz,sameXyz,lw,scale,ccmatrix)

[iy,ix,iz] = size(xyz);

cx2u = makecform('xyz2upvpl');
cu2x = makecform('upvpl2xyz');
monitorMaxUpvpl = applycform(transpose(rgb2XYZ([1 1 1]',ccmatrix)),cx2u);
monitorMaxLum = monitorMaxUpvpl(3);
monitorMinUpvpl = applycform(transpose(rgb2XYZ([0 0 0]',ccmatrix)),cx2u);
monitorMinLum = monitorMinUpvpl(3);
upvpl = applycform(xyz,cx2u);
disp(strcat('max luminance: ',num2str(monitorMaxLum)));
a = max(max(applycform(sameXyz,cx2u)));
sh = 8;

% Reinhard function
for i = 1:iy
    for j = 1:ix
        x = upvpl(i,j,3)/a(3);
        upvpl(i,j,3) = monitorMaxLum * x*sh/(1+x*sh)*(1+x*sh/lw^2);
        %upvpl(i,j,3) = maxLum * x.^(1/lw);
        %upvpl(i,j,3) = maxLum * log(1+lw*x);
        if upvpl(i,j,3) > monitorMaxLum
            upvpl(i,j,3) = monitorMaxLum;
        elseif upvpl(i,j,3) < 0
            upvpl(i,j,3) = 0;
        end
    end
end

upvpl = applycform(xyz,cx2u);
minUpvpl = min(min(applycform(sameXyz,cx2u)));
upvpl(:,:,3) = upvpl(:,:,3) - minUpvpl(3);
upvpl(:,:,3) = upvpl(:,:,3) * scale;
upvpl(:,:,3) = upvpl(:,:,3)*(monitorMaxLum-monitorMinLum)/(monitorMaxLum-minUpvpl(3));
upvpl(:,:,3) = upvpl(:,:,3) + monitorMinLum;

tonemappedXYZ = applycform(upvpl,cu2x);

end
