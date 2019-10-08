% a = zeros(5,4,3);
% for i = 1:5
%     for j = 1:4
%         for k = 1:3
%             a(i,j,k) = k+(j-1)*3+(i-1)*4*3;
%         end 
%     end
% end
% permuted = permute(a,[3 2 1]);
% reshaped = reshape(permuted,[3,4*5]);
% reshaped2 = reshape(reshaped,[3 4 5]);
% permuted2 = permute(reshaped2,[3 2 1]);
% permuted2

for i = 1:1
    a = wtXYZ2rgb(wtTonemap(SDsame(:,:,:,i),2,707/4,1/10),ccmatrix);
    wtColorCheck(a);
    imshow(a);
end
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