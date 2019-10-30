% -------------------
% InitNStair (ver.1)
% -------------------
%
% Initialize and create a Staircase variable. Return it.
%
% How to use: oq = InitNStair(stilevelnum, startlevel, nupdown, crikind, criterion)
%    stilevelnum: level number of stimlus intensity
%    startlevel:  stimulus level at beginning of staircase
%    nupdown:     "n"-down 1-up procedure
%    crikind:     'r'...finish staircase based on returning number
%                 't'...finish staircase based on trial number
%    criterion:   returning number or trial number for finishing judgement of stairecase
%
% Created by Takehiro Nagai on 12/15/2007
%

function q = InitNStair(stilevelnum,startlevel,nupdown,crikind,criterion)

% error process
if crikind ~= 'r' && crikind ~= 't' 
    error('crikind must be "r"(return number) or "t"(trial nmber). ');
end

if stilevelnum < 2
    error('stilevelnum must be more than 1.')
end

if startlevel < 1 || startlevel > stilevelnum
    error('startlevel must be between 1 and stilevelnum')
end

if nupdown < 1
    error('nupdown must be more than 1.');
end

if criterion < 1
    error('criterion must be more than 1.');
end


% variables setting
q.intensity = [];
q.response = [];
q.returnlevel = [];
q.trialnum = 0;
q.finishflag = 0;
q.returnnum = 0;
q.continuecorrect = 0;

q.nupdown = nupdown;
q.stilevelnum = stilevelnum;
q.currentlevel = startlevel;
q.crikind = crikind;               % 'r':return number , 't':trial number
q.criterion = round(criterion);    % finish judgement criterion (return number or trial number)
q.lreturn = 0;                     % previous return direction, 0:no return, 1:low level, 2:high level
