%%% RenderToolbox4 Copyright (c) 2012-2016 The RenderToolbox Team.
%%% About Us://github.com/RenderToolbox/RenderToolbox4/wiki/About-Us
%%% RenderToolbox4 is released under the MIT License.  See LICENSE file.
%
%% Render the Dragon scene.

%% Choose example files, make sure they're on the Matlab path.
parentSceneFile = blendFile;
mappingsFile = 'SphereDataMappings2.json';

%% Choose batch renderer options.
nSteps = 1;
hints.imageWidth = 320*magnification;
hints.imageHeight = 240*magnification;
hints.fov = 49.13434 * pi() / 180;
hints.recipeName = mfilename();

%% Render with Mitsuba and PBRT.
toneMapFactor = 10;
isScale = true;
renderer = 'Mitsuba';
hints.renderer = renderer;
    
nativeSceneFiles = rtbMakeSceneFiles(parentSceneFile, ...
    'mappingsFile', mappingsFile, ...
    'hints', hints);
radianceDataFiles = rtbBatchRender(nativeSceneFiles, 'hints', hints);
    
for ii = 1:nSteps
    [SRGBMontage, XYZMontage] = ...
        rtbMakeMontage(radianceDataFiles, ...
        'toneMapFactor', toneMapFactor, ...
        'isScale', isScale, ...
        'hints', hints);
    rtbShowXYZAndSRGB([], SRGBMontage, sprintf('%s (%s)', hints.recipeName, hints.renderer));
end