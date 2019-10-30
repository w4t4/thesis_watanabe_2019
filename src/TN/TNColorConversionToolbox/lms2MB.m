% lms2MB (ver1.0)  
% 
% Calculate (modified) MacLeod-Boynton coodinates from LMS values, in addition to luminance values.
% This functions assume that LMS values are based on Smith-Pokorny
% fundamentals (1975).
%
% L_MB(1) is luminance, L_MB(2) is L-M, and L_MB(3) is S.
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Usage: 
%    L_MB = lms2MB(lms, stdchr, thr);
%   
% Input:  
%   lms:    LMS matrix, ([0.1 0.2 0.5] or [0.2 0.3 0.4;  0.3 0.4 0.5], these values are calculated just by multiplying cone fundamentals and spectral radiance)
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

function L_MB = lms2MB(lms, stdchr, thr)
% parameters for ajudstment
if nargin<3
    thr = [1;1];
end
if nargin<2
    stdchr = [0;0];
end

colmunlen = size(lms,2);
baseL_MB = zeros(3, colmunlen);

% calculate basic MB corrdinates
baseL_MB(1, :) = lms(1, :)+lms(2, :);
baseL_MB(2, :) = (lms(1, :))./(lms(1, :)+lms(2, :));
baseL_MB(3, :) = lms(3, :)./(lms(1, :)+lms(2, :));

% adjust corrdinate if desired
L_MB = baseL_MB;
L_MB(2, :) = (L_MB(2, :) - stdchr(1))./thr(1);
L_MB(3, :) = (L_MB(3, :) - stdchr(2))./thr(2);








