m = 1/2;
for i = 1:9
    a = wtXYZ2rgb(wtTonemap(SDsame(:,:,:,i),60/m,m),ccmatrix);
    wtColorCheck(a);
    figure;
    imshow(a);
end
montage(a, 'size', [3 3]);
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