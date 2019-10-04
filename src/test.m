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

for i = 1:9
    a = wtXYZ2rgb(wtTonemap(SDsame(:,:,:,i),80),ccmatrix);
    wtColorCheck(a);
    figure;
    imshow(a);
end
