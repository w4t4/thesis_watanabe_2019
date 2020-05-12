load('mat/ccmat.mat');

load('./mat/Dragon/coloredSD.mat');
load('./mat/Dragon/coloredD.mat');
[ix,iy,iz] = size(coloredSD(:,:,:,1));
dragonSD = zeros(ix,iy,iz,9);
dragonD = zeros(ix,iy,iz,9);

for i = 1:9
    dragonSD(:,:,:,i) = wImageXYZ2rgb_wtm(coloredSD(:,:,:,i),ccmat);
end
for i = 1:9
    dragonD(:,:,:,i) = wImageXYZ2rgb_wtm(coloredD(:,:,:,i),ccmat);
end
save('./stimuli/dragonSD.mat','dragonSD');
save('./stimuli/dragonD.mat','dragonD');
figure;
montage(dragonSD/255,'size',[3 3]);
figure;
montage(dragonD/255,'size',[3 3]);

load('./mat/Bunny/coloredSD.mat');
load('./mat/Bunny/coloredD.mat');
bunnySD = zeros(ix,iy,iz,9);
bunnyD = zeros(ix,iy,iz,9);

for i = 1:9
    bunnySD(:,:,:,i) = wImageXYZ2rgb_wtm(coloredSD(:,:,:,i),ccmat);
    %wtColorCheck(Dsame);
end
for i = 1:9
    bunnyD(:,:,:,i) = wImageXYZ2rgb_wtm(coloredD(:,:,:,i),ccmat);
    %wtColorCheck(Dsame);
end
save('./stimuli/bunnySD.mat','bunnySD');
save('./stimuli/bunnyD.mat','bunnyD');
figure;
montage(bunnySD/255,'size',[3 3]);
figure;
montage(bunnyD/255,'size',[3 3]);

