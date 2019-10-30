% TNColorConversionToolbox
% 
% How to use:
% ---DKL<->LMS---
% Use DKL2lms.m or lms2DKL.
% Background lms values (and detection thresholds on each of DKL axes) are necessary.
% 
% ---rgb(0-1)<->XYZ, XYZ modified by Judd, LMS---
% 1.Preparation
% Create a Color Conversion Matrix with makergbLMSmatrix.m 
% (It's easy to save the matrix to a file, and load the file when running experiments.
% Don't have to create the matrix on each experimental session.
% 2.Conversion
% Multiply the matrix (such as ccmat.rgb2lms) and a source color matrix (such as rgb (=[0.9;0.6;0.3]))
% e.g. 
% rgb = [0.8;0.1;0.4];
% lms = ccmat.rgb2lms * rgb;
% 
% ---rgb(0-1) to RGB(1-65536) on Bits++---
% 1.Preparation
% Use udtmeasBitsPTB3_menu.m in BitsCalibration.
% 2.Conversion
% Use each of rgb2RGB_fitting.m, rgb2RGB_LUT.m, or rgb2RGB_iLUT.m
%
% Created by Takehiro Nagai on 06/06/2009

