load('ccmatrix.mat');

load('../img/mag3_dl/SDsameDragon.mat');
load('../img/mag3_dl/SDdifferentDragon.mat');
[ix,iy,iz] = size(SDsame(:,:,:,1));
Dsame = zeros(ix,iy,iz,9);
Ddiff = zeros(ix,iy,iz,9);

m = 1/2;
l = 60;

for i = 1:9
    Dsame(:,:,:,i) = wtXYZ2rgb(wtTonemap(SDsame(:,:,:,i),l/m,m),ccmatrix);
    %wtColorCheck(Dsame);
end
save('../img/dragon/Dsame.mat','Dsame');
for i = 1:9
    Ddiff(:,:,:,i) = wtXYZ2rgb(wtTonemap(SDdifferent(:,:,:,i),l/m,m),ccmatrix);
    %wtColorCheck(Dsame);
end
save('../img/dragon/Ddiff.mat','Ddiff');
figure;
montage(Dsame,'size',[3 3]);
figure;
montage(Ddiff,'size',[3 3]);

load('../img/mag3_dl/SDsameBunny.mat');
load('../img/mag3_dl/SDdifferentBunny.mat');
Bsame = SDsame;
Bdiff = SDdifferent;

for i = 1:9
    Bsame(:,:,:,i) = wtXYZ2rgb(wtTonemap(SDsame(:,:,:,i),l/m,m),ccmatrix);
    %wtColorCheck(Dsame);
    save('../img/bunny/Bsame.mat','Bsame');
end
for i = 1:9
    Bdiff(:,:,:,i) = wtXYZ2rgb(wtTonemap(SDdifferent(:,:,:,i),l/m,m),ccmatrix);
    %wtColorCheck(Dsame);
    save('../img/bunny/Bdiff.mat','Bdiff');
end
figure;
montage(Bsame,'size',[3 3]);
figure;
montage(Bdiff,'size',[3 3]);

% load('../img/mag1_dl/SDsameSphere.mat');
% load('../img/mag1_dl/SDdifferentSphere.mat');
% Ssame = SDsame;
% Sdiff = SDdifferent;
