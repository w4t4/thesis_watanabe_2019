clear all
close all

% render size
% width = 320*magnification
% height = 240*magnification
magnification = 3;
% select blend file
% 'Dragon.blend' or 'Bunny.blend' or 'Sphere.blend'
blendFile = 'Sphere.blend';

% get mask and data
run('../render/dragonMask.m');
xyzMask = XYZMontage;
if strcmp(blendFile,'Sphere.blend') == 1
    run('../render/sphereData.m');
    xyzData = XYZMontage;
    run('../render/sphereSpecular.m');
    xyzSpecular = XYZMontage;
    run('../render/sphereDiffuse.m');
    xyzDiffuse = XYZMontage;

else
    run('../render/dragonData.m');
    xyzData = XYZMontage;
    run('../render/dragonSpecular.m');
    xyzSpecular = XYZMontage;
    run('../render/dragonDiffuse.m');
    xyzDiffuse = XYZMontage;

end

run('mask.m');
% run('colorize_mat.m');