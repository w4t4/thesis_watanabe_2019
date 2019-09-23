clear all
close all

% dragon size
% width = 320*magnification
% height = 240*magnification
magnification = 3;
% select blend file
% 'Dragon.blend' or 'Bunny2.blend' or 'sphere.blend'
blendFile = 'Dragon.blend';

% get mask and data
run('../Dragon/dragonMask.m');
xyzMask = XYZMontage;
run('../Dragon/dragonData.m');
xyzData = XYZMontage;
run('../Dragon/dragonSpecular.m');
xyzSpecular = XYZMontage;
run('../Dragon/dragonDiffuse.m');
xyzDiffuse = XYZMontage;

run('mask.m');
run('colorize_mat.m');