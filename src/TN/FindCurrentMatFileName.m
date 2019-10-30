% FindCurrentMatFileName (ver.1)
%
% Find the old mat file with the same name component.
% 
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Usage: 
% [nfn loc] = FindCurrentMatFileName(fn, fldr)
%
% Input:
%   fn:    Base file name without extension
%   fldr:  Folder name to search for older files
% 
% OutPut:
%   nfn:   New file name without extension
%   loc:   'loc'th generation file(1,2,3...)
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Created by Takehiro Nagai on 12/20/2007 (ver.1)
%

function [nfn loc]=FindCurrentMatFileName(fn, fldr)

found = 0;
loc = 1;
fname = fn;
while found ~= 1
    if exist([fldr fname '.mat'],'file')~=0    % found
        loc = loc + 1;
        fname = SetSuccsessiveFileName(fn, loc); % set next file name
    else    % not found, use as new file name
        found = 1;
    end
end

nfn = fname;
