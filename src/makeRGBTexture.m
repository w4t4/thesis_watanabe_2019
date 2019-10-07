load('ccmatrix.mat');

load('../img/mag3_dl/SDsameDragon.mat');
load('../img/mag3_dl/SDdifferentDragon.mat');
[ix,iy,iz] = size(SDsame(:,:,:,1));
Dsame = zeros(ix,iy,iz,9);
Ddiff = zeros(ix,iy,iz,9);

for i = 1:9
    Dsame(:,:,:,i) = wtXYZ2rgb(wtTonemap(SDsame(:,:,:,i),90,833),ccmatrix);
    %wtColorCheck(Dsame);
end
save('../img/dragon/Dsame.mat','Dsame');
for i = 1:9
    Ddiff(:,:,:,i) = wtXYZ2rgb(wtTonemap(SDdifferent(:,:,:,i),90,833),ccmatrix);
    %wtColorCheck(Dsame);
end
save('../img/dragon/Ddiff.mat','Ddiff');
figure;
montage(Dsame,'size',[1 9]);
figure;
montage(Ddiff,'size',[1 9]);

load('../img/mag3_dl/SDsameBunny.mat');
load('../img/mag3_dl/SDdifferentBunny.mat');
Bsame = SDsame;
Bdiff = SDdifferent;

for i = 1:9
    Bsame(:,:,:,i) = wtXYZ2rgb(wtTonemap(SDsame(:,:,:,i),90,833),ccmatrix);
    %wtColorCheck(Dsame);
    save('../img/bunny/Bsame.mat','Bsame');
end
for i = 1:9
    Bdiff(:,:,:,i) = wtXYZ2rgb(wtTonemap(SDdifferent(:,:,:,i),90,833),ccmatrix);
    %wtColorCheck(Dsame);
    save('../img/bunny/Bdiff.mat','Bdiff');
end
figure;
montage(Bsame,'size',[1 9]);
figure;
montage(Bdiff,'size',[1 9]);

% load('../img/mag1_dl/SDsameSphere.mat');
% load('../img/mag1_dl/SDdifferentSphere.mat');
% Ssame = SDsame;
% Sdiff = SDdifferent;
