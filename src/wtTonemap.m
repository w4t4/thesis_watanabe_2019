function tonemappedXYZ = wtTonemap(xyz,mode)

%thr = 80くらいが光沢感を保てるかも?

[iy,ix,iz] = size(xyz);
mat = zeros(iy,ix,iz);
maxlum = 110; 
cx2u = makecform('xyz2upvpl');
cu2x = makecform('upvpl2xyz');
uvl = applycform(xyz,cx2u);
mat = uvl;

if mode == 1
    % linear and log filter
    m = 1/2;
    thr = 80/m;
    [a, b] = wtSolve(m,thr); 
    isMaxlumOver = xyz(:,:,1) > thr;
    for i = 1:iy
        for j = 1:ix
            %disp(uvl(i,j,3));
            mat(i,j,3) = (1-isMaxlumOver(i,j)) * m*uvl(i,j,3) + isMaxlumOver(i,j) * a*log(uvl(i,j,3)+b);
            if mat(i,j,3) > maxlum
                mat(i,j,3) = maxlum;
            elseif mat(i,j,3) < 0
                mat(i,j,3) = 0;
            end
        end
    end
elseif mode == 2
    % Reinhard
    l = 10;
    for i = 1:iy
        for j = 1:ix
            x = uvl(i,j,3)/maxlum;
            mat(i,j,3) = maxlum * x/(1+x)*(1+x/l^2);
            if mat(i,j,3) > maxlum
                mat(i,j,3) = maxlum;
            elseif mat(i,j,3) < 0
                mat(i,j,3) = 0;
            end
        end
    end
end

tonemappedXYZ = applycform(mat,cu2x);

end
