b = zeros(720,960,3,9);
for i = 1:1
    a = wtXYZ2rgb(wtTonemap(xyzSD(:,:,:)),ccmatrix);
    wtColorCheck(a);
    b(:,:,:,i) = a;
    %figure;
    %imshow(a);
end
figure;
montage(b, 'size', [1 1]);
% Dragon: colorDistanceRate:30,thr:90,materialMaxlum:833
% Bunny: colorDistanceRate:30,thr:90,materialMaxlum:833
% Sphere: colorDistanceRate:,thr:,materialMaxlum:707

% xyz = SDsame(:,:,:,1);
% [iy,ix,iz] = size(xyz);
% maxyz = 0;
% for i = 1:iy
%     for j = 1:ix
%         if maxyz < xyz(i,j,1)
%             maxyz = xyz(i,j,1);
%         end
%     end
% end
% maxyz

% m=2, 30/m