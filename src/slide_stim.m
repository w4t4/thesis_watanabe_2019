A = zeros(size(Dsame));
A(:,:,:,1) = Dsame(:,:,:,1);
for i = 2:9
    A(:,:,:,i) = Dsame(:,:,:,11-i);
end
montage(A/255,'size',[3 3]);

% B = A;
% B(:,:,:,1) = [];
% montage(B/255,'size',[2 4]);