% log2linear (ver.1.5)
% 
% Translate (linear) x (0~1) to (log dimension) y (0~1).
% Useful for experiment with luminance acis experiment. 
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Usage:
%     y = log2linear(x,logp);
% 
% Input:
%     x:    log dimension value (0-1).
%     logp: Log parameter (log dimension 0~1 is translated to -logp~0 linearly,
%           and then to linear dimension 0~1.)
%
% Output:
%     y:    linear value (0-1).
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
%     
% Created by Takehiro Nagai on 07/01/2007 (ver.1.5)
% 

function y = log2linear(x,logp)

nx = (x-1) .* logp;
y = exp(nx);