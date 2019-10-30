% deg2pix (ver.1.0)
% 
% Calculate a stimulus size (pixel) corresponding to a visual angle on a CRT.
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Usage:
%     wcm = deg2pix(wdeg, distance, CRTwidthcm, CRTwidthpixel);
% 
% Input:
%     wdeg:          Stimulus size (deg).
%     distance:      Viewing distance (cm).
%     CRTwidthcm:    CRT width in cm.
%     CRTwidthpixel: CRT width in pixel.
%
% Output:
%     wpix:           Stimulus size (cm).
%
% Other explanation:
%     wdeg can be a vector or matrix.
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
%     
% Created by Takehiro Nagai on 06/05/2009 (ver.1)
% 

function wpix = deg2pix(wdeg, distance, CRTwidthcm, CRTwidthpixel)

wcm = deg2cm(wdeg, distance);
wpix = round(wcm./CRTwidthcm.*CRTwidthpixel);





