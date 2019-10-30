% linear2log (ver.1.5)
% 
% Translate (linear) x (0~1) to (log dimension) y (0~1).
% Useful for experiment with luminance acis experiment. 
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Usage:
%     y = linear2log(x,logp);
% 
% Input:
%     x:    linear value (0-1).
%     logp: Log parameter (linear 0~1 is translated to -logp~0,
%           and then to 0~1 by linear transformation.)
%
% Output:
%     y:    log dimansion value (0-1).
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
%     
% Created by Takehiro Nagai on 07/01/2007 (ver.1.5)
% 

function y = linear2log(x,logp)

y = log(x)./logp + 1;
