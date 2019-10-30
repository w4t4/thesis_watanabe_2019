% MB2lms (ver1.0)  
% 
% Calculate LMS values from (modified) MacLeod-Boynton coodinates including luminance values.
% This functions assume that LMS values are based on Smith-Pokorny
% fundamentals (1975).
%
% L_MB(1) is luminance, L_MB(2) is L-M, and L_MB(3) is S.
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Usage: 
%   lms = MB2lms(L_MB, stdchr, thr)
%   
% Input:
%   L_MB:   luminance and chromaticiy matrix ([30 0.2 0.5] or [20 0.3 0.4; 15 0.4 0.5]
%   stdchr: Base point ([0.3 1]) on chromaticity diagram, if desired. This point
%   is regarded as origin.
%   thr:    detection/discrimination thresholds on r, g axis (ex. [0.1 0.07
%   0.09]), if axis scaling is desired.
% Output:
%   lms:  LMS matrix (the same size as the L_MB matrix)
%
% Comments:
%   None.
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%
% Created by Takehiro Nagai on 09/03/2014 (ver.1)
%

function lms = MB2lms(L_MB, stdchr, thr)
% parameters for ajudstment
if nargin<3
    thr = [1;1];
end
if nargin<2
    stdchr = [0;0];
end

colmunlen = size(L_MB,2);
lms = zeros(3, colmunlen);

% adjust to base MB space
baseL_MB = L_MB;
baseL_MB(2, :) = (L_MB(2, :).*thr(1)) + stdchr(1);
baseL_MB(3, :) = (L_MB(3, :).*thr(2)) + stdchr(2);

% calculate lms values
lms(1, :) = baseL_MB(1, :) .* baseL_MB(2, :);
lms(2, :) = baseL_MB(1, :) - lms(1, :);
lms(3, :) = baseL_MB(1, :) .* baseL_MB(3, :);






