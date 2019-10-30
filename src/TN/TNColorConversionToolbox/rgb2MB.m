% rgb2MB (ver1.0)  
% 
% Calculate (modified) MacLeod-Boynton coodinates from rgb values, in addition to luminance values.
% This functions assume that LMS values are based on Smith-Pokorny
% fundamentals (1975).
%
% L_MB(1) is luminance, L_MB(2) is L-M, and L_MB(3) is S.
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Usage: 
%    L_MB = rgb2MB(rgb, ccmat, stdchr, thr);
%   
% Input:  
%   rgb:    rgb matrix, ([0.1 0.2 0.5] or [0.2 0.3 0.4;  0.3 0.4 0.5].
%   stdchr: Base point ([0.3 1]) on chromaticity diagram, if desired. This point
%   is regarded as origin.
%   thr:    detection/discrimination thresholds on r, g axis (ex. [0.1 0.07
%   0.09]), if axis scaling is desired.
% Output:
%   L_MB:   Luminance and chromaticity (e.g., [Lum; r; g])
%
% Comments:
%   None.
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%
% Created by Takehiro Nagai on 09/03/2014 (ver.1)
%

function L_MB = rgb2MB(rgb, ccmat, stdchr, thr)
% parameters for ajudstment
if nargin<4
    thr = [1;1];
end
if nargin<3
    stdchr = [0;0];
end

lms = rgb2lms(rgb, ccmat);
L_MB = lms2MB(lms, stdchr, thr);








