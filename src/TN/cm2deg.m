% cm2deg (ver.1.0)
% 
% Calculate a visual angle corresponding to a stimulus size (cm) on a CRT vertical to a visual axis.
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Usage:
%     wdeg = HelpTemplate(input1, input2);
% 
% Input:
%     wcm:      Stimulus size (cm).
%     distance: Viewing distance (cm).
%
% Output:
%     wdeg:     Visual angle (deg) of the stimulus size.
%
% Other explanation:
%     wcm can be a vector or matrix.
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
%     
% Created by Takehiro Nagai on 06/23/2008 (ver.1)
% 

function wdeg = cm2deg(wcm, distance)

wdeg = atan2(wcm./2, distance)./pi.*180.*2;



