% ---------------------
% CurrentNStair (ver.1)
% ---------------------
%
% Return stimulus level based on Staircase variable.
% Or return 0 if the staircase has been done.
%
% How to use: stilevel = CurrentNStair(q)
%    q: staircase variable
%
% Created by Takehiro Nagai on 12/15/2007

function stilevel = CurrentNStair(q)

if q.finishflag 
    stilevel = 0;
else
    stilevel = q.currentlevel;
end