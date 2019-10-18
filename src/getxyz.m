clear all
close all

% dragon size
% width = 320*magnification
% height = 240*magnification
magnification = 3;
% select blend file
% 'Dragon.blend' or 'Bunny.blend' or 'Sphere.blend'
blendFile = 'Bunny.blend';

% get mask and data
run('../Dragon/dragonMask.m');
xyzMask = XYZMontage;
if strcmp(blendFile,'Sphere.blend') == 1
    run('../Dragon/sphereData.m');
    xyzData = XYZMontage;
    run('../Dragon/sphereSpecular.m');
    xyzSpecular = XYZMontage;
    run('../Dragon/sphereDiffuse.m');
    xyzDiffuse = XYZMontage;

else
    run('../Dragon/dragonData.m');
    xyzData = XYZMontage;
    run('../Dragon/dragonSpecular.m');
    xyzSpecular = XYZMontage;
    run('../Dragon/dragonDiffuse.m');
    xyzDiffuse = XYZMontage;

end

run('mask.m');
% run('colorize_mat.m');