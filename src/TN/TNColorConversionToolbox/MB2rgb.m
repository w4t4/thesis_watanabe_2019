% MB2rgb (ver1.0)  
% 
% Calculate rgb values from (modified) MacLeod-Boynton coodinates including luminance values.
% This functions assume that LMS values are based on Smith-Pokorny
% fundamentals (1975).
%
% L_MB(1) is luminance, L_MB(2) is L-M, and L_MB(3) is S.
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Usage: 
%   rgb = MB2rgb(L_MB, stdchr, thr)
%   
% Input:
%   L_MB:   luminance and chromaticiy matrix ([30 0.2 0.5] or [20 0.3 0.4; 15 0.4 0.5]
%   stdchr: Base point ([0.3 1]) on chromaticity diagram, if desired. This point
%   is regarded as origin.
%   thr:    detection/discrimination thresholds on r, g axis (ex. [0.1 0.07
%   0.09]), if axis scaling is desired.
% Output:
%   rgb:  rgb matrix (the same size as the L_MB matrix)
%
% Comments:
%   None.
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%
% Created by Takehiro Nagai on 09/03/2014 (ver.1)
%

function rgb = MB2rgb(L_MB, ccmat, stdchr, thr)
% parameters for ajudstment
if nargin<4
    thr = [1;1];
end
if nargin<3
    stdchr = [0;0];
end


lms = MB2lms(L_MB, stdchr, thr);
rgb = lms2rgb(lms, ccmat);







