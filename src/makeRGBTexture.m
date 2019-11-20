load('mat/ccmat.mat');

load('../img/mag3/SDsameDragon.mat');
load('../img/mag3/SDdifferentDragon.mat');
[ix,iy,iz] = size(SDsame(:,:,:,1));
Dsame = zeros(ix,iy,iz,9);
Ddiff = zeros(ix,iy,iz,9);

m = 1/2;
l = 60;

for i = 1:9
    Dsame(:,:,:,i) = wImageXYZ2rgb_wtm(SDsame(:,:,:,i),ccmat);
    %wtColorCheck(Dsame);
end
for i = 1:9
    Ddiff(:,:,:,i) = wImageXYZ2rgb_wtm(SDdifferent(:,:,:,i),ccmat);
    %wtColorCheck(Dsame);
end
save('../img/dragon/Dsame.mat','Dsame');
save('../img/dragon/Ddiff.mat','Ddiff');
figure;
montage(Dsame/255,'size',[3 3]);
figure;
montage(Ddiff/255,'size',[3 3]);

load('../img/mag3/SDsameBunny.mat');
load('../img/mag3/SDdifferentBunny.mat');
Bsame = SDsame;
Bdiff = SDdifferent;

for i = 1:9
    Bsame(:,:,:,i) = wImageXYZ2rgb_wtm(SDsame(:,:,:,i),ccmat);
    %wtColorCheck(Dsame);
    save('../img/bunny/Bsame.mat','Bsame');
end
for i = 1:9
    Bdiff(:,:,:,i) = wImageXYZ2rgb_wtm(SDdifferent(:,:,:,i),ccmat);
    %wtColorCheck(Dsame);
    save('../img/bunny/Bdiff.mat','Bdiff');
end
figure;
montage(Bsame/255,'size',[3 3]);
figure;
montage(Bdiff/255,'size',[3 3]);

% load('../img/mag3/SDsameSphere.mat');
% load('../img/mag3/SDdifferentSphere.mat');
% Ssame = SDsame;
% Sdiff = SDdifferent;
% for i = 1:9
%     Ssame(:,:,:,i) = wImageXYZ2rgb_wtm(SDsame(:,:,:,i),ccmat);
%     %wtColorCheck(Dsame);
%     save('../img/sphere/Ssame.mat','Ssame');
% end
% for i = 1:9
%     Sdiff(:,:,:,i) = wImageXYZ2rgb_wtm(SDdifferent(:,:,:,i),ccmat);
%     %wtColorCheck(Dsame);
%     save('../img/sphere/Sdiff.mat','Sdiff');
% end
% %figure;
% %montage(Ssame,'size',[3 3]);
% %figure;
% %montage(Sdiff,'size',[3 3]);
