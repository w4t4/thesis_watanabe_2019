function tonemappedXYZ = wtTonemap(xyz,thr,m)

%thr = 80くらいが光沢感を保てるかも?

[iy,ix,iz] = size(xyz);
mat = zeros(iy,ix,iz);
isMaxlumOver = xyz(:,:,1) > thr;
maxlum = 97; 
[a, b] = wtSolve(m,thr); 

cx2u = makecform('xyz2upvpl');
cu2x = makecform('upvpl2xyz');
uvl = applycform(xyz,cx2u);
mat = uvl;
for i = 1:iy
    for j = 1:ix
        %disp(uvl(i,j,3));
        mat(i,j,3) = (1-isMaxlumOver(i,j)) * m*uvl(i,j,3) + isMaxlumOver(i,j) * a*log(uvl(i,j,3)+b);
        if mat(i,j,3) > maxlum
            mat(i,j,3) = maxlum;
        end
    end
end

tonemappedXYZ = applycform(mat,cu2x);

end
