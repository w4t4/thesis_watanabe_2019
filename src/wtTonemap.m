function tonemappedXYZ = wtTonemap(xyz,thr)

%thr = 80くらいが光沢感を保てるかも?

[iy,ix,iz] = size(xyz);
mat = zeros(iy,ix,iz);
isMaxlumOver = xyz(:,:,1) > thr;
maxlum = 93;
m = 1/2; % y = mx (0 <= x < thr) 
a = maxlum/log(500); %  magic number XD
b = thr - exp(m*thr/a);
imm = 0;
for i = 1:iy
    for j = 1:ix
        for k = 1:iz
            mat(i,j,k) = (1-isMaxlumOver(i,j)) * m*xyz(i,j,k) + isMaxlumOver(i,j) * a*log(xyz(i,j,k)-b);
             if mat(i,j,k) > maxlum
                 mat(i,j,k) = maxlum;
             end
             if imm < mat(i,j,k)
                 imm = mat(i,j,k);
             end
        end
    end
end
tonemappedXYZ = mat;

end