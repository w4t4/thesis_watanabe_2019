% SetSuccsessiveFileName (ver.1)
%
% Create 'n'th generation file name with a name component.
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Usage: 
% nfn = SetSuccsessiveFileName(fn, loc)
%
% Input:
%   fn:   Base file name without extension
%   loc:  File generation
% 
% OutPut:
%   nfn:   New file name without extension
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Created by Takehiro Nagai on 12/20/2007 (ver.1)
%

function nfn = SetSuccsessiveFileName(fn, loc)

if loc ~=1
    nfn= [fn,'_','(',num2str(loc),')'];
else
    nfn = fn;
end

