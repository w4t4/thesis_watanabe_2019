% DKL2lms_normalize_test (ver1.0)  
% 
% Calculate LMS values from DKL cordinates.
% This function modified the original DKL space
% to prevent chromaticity differences between 
% different luminance values.
%
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Usage: 
%    lms = DKL2lms_normalize_test(DKL, stdlms, thr);
%   
% Input:  
%   DKL:    DKL matrix, ([0.1; 0.2; 0.5] or [0.2 0.3; 0.4 0.3; 0.4 0.5], these values are DKL coodinates after normalization by thresholds)
%   stdlms: LMS matrix of neutral point subject adapted to (ex. [0.1; 0.07; 0.09])
%   thr:    detection/discrimination thresholds on each axis of DKL space (ex. [0.1; 0.07; 0.09])
% Output:
%   lms:    LMS matrix (the same size as the DKL matrix)
%
% Comments:
%   L=(2*Lum*(LM+1)+4*LM)/(LM+5)
%   M=(2*Lum*(-LM+1)-6*LM)/(LM+5)
%   S=(Slum(2*Lum+5)+2*lum-LM)/(LM+5)
%   
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%
% Created by Takehiro Nagai on 07/19/2016 (ver.1)
% 

function lms = DKL2lms_normalize_test(DKL, stdlms, thr)

% calculate lms values
% lmsc = [((DKL(2,:).*thr(2)).*(DKL(1,:).*thr(1)+2)+DKL(1,:).*thr(1))./2;...
%         ((-DKL(2,:).*thr(2)).*(DKL(1,:).*thr(1)+2)+DKL(1,:).*thr(1))./2;...
%         ((DKL(3,:).*thr(3)).*(DKL(1,:).*thr(1)+2)+DKL(1,:).*thr(1))./2];
DKLn = [DKL(1,:).*thr(1);DKL(2,:).*thr(2);DKL(3,:).*thr(3);];

lmsc = [(2.*DKLn(1,:).*(DKLn(2,:)+1)+4.*DKLn(2,:))./(DKLn(2,:)+5);
        (2.*DKLn(1,:).*(-DKLn(2,:)+1)-6.*DKLn(2,:))./(DKLn(2,:)+5);
        (DKLn(3,:).*(2.*DKLn(1,:)+5)+2.*DKLn(1,:)-DKLn(2,:))./(DKLn(2,:)+5)];

colmunlen = size(DKL,2);
stdlmsmat = repmat(stdlms, 1, colmunlen);
lms = (lmsc.*stdlmsmat) + stdlmsmat;







