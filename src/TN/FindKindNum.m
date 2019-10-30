% FindKindNum (ver.1.5)
% 
% Find the number of element kinds in an array.
% (However, this version may not be fast...)
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Usage:
%     [num, kind] = FindKindNum(data)
% 
% Input:
%     data: Data array, not matrix for this version
%
% Output:
%     num:  Number of element kinds (scalar).
%     kind: Each different element (array sorted).
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
%     
% Created by Takehiro Nagai on 01/03/2008 (ver.1)
% 

function [num, kind] = FindKindNum(data)

kind = [];
notfound = ones(size(data));
for i = 1:length(data)
    if notfound(i)
        comp = ( data(i) == data );
        kind = [kind data(i)];
        notfound = notfound .* abs(1-comp);
    end
end

num = length(kind);
kind = sort(kind);

