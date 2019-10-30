% deg2cm (ver.1.0)
% 
% Calculate a visual angle corresponding to a stimulus size (cm) on a CRT vertical to a visual axis.
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Usage:
%     wcm = deg2cm(wdeg, distance);
% 
% Input:
%     wdeg:     Stimulus size (deg).
%     distance: Viewing distance (cm).
%
% Output:
%     wcm:      Stimulus size (cm).
%
% Other explanation:
%     wdeg can be a vector or matrix.
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
%     
% Created by Takehiro Nagai on 06/05/2009 (ver.1)
% 

function wcm = deg2cm(wdeg, distance)

wcm = (tan(wdeg./2./180.*pi)).*distance.*2;

