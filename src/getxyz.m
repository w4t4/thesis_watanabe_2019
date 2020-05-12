%% blendファイルを指定しRTB4にレンダリングのジョブを投げるプログラム

clear all
close all

% width = 320*magnification
% height = 240*magnification
magnification = 3;
% select blend file
% 'Dragon.blend' or 'Bunny.blend'
blendFile = 'Bunny.blend';

% get mask and data
run('./render/dragonMask.m');
xyzMask = XYZMontage;
run('./render/dragonData.m');
xyzData = XYZMontage;
run('./render/dragonSpecular.m');
xyzSpecular = XYZMontage;
run('./render/dragonDiffuse.m');
xyzDiffuse = XYZMontage;

run('mask.m');

xyzSD = maskedData;
xyzD = maskedDiffuse;
xyzS = maskedSpecular;

if blendFile == 'Dragon.blend'
    save('./mat/Dragon/xyzSD','xyzSD');
    save('./mat/Dragon/xyzD','xyzD');
    save('./mat/Dragon/xyzS','xyzS');
elseif blendFile == 'Bunny.blend'
    save('./mat/Bunny/xyzSD','xyzSD');
    save('./mat/Bunny/xyzD','xyzD');
    save('./mat/Bunny/xyzS','xyzS');
end
    