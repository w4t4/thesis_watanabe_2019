function tonemappedXYZ = wtTonemap(xyz,thr,m)

%thr = 80くらいが光沢感を保てるかも?

[iy,ix,iz] = size(xyz);
mat = zeros(iy,ix,iz);
isMaxlumOver = xyz(:,:,1) > thr;
maxlum = 97;
%m = 1/2; % y = mx (0 <= x < thr) 
[a, b] = wtSolve(m,thr); 
%disp(m*thr - a*log(thr+b));
for i = 1:iy
    for j = 1:ix
        for k = 1:iz
            mat(i,j,k) = (1-isMaxlumOver(i,j)) * m*xyz(i,j,k) + isMaxlumOver(i,j) * a*log(xyz(i,j,k)+b);
             if mat(i,j,k) > maxlum
                 mat(i,j,k) = maxlum;
             end
        end
    end
end
tonemappedXYZ = mat;

end