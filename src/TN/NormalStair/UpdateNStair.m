% ---------------------
% UpdateNStair (ver.1)
% ---------------------
%
% Update the staircase based on the stimulus level and subject's response.
%
% How to use: oq = UpdateNStair(iq,intensity,response)
%    iq:        staircase variable
%    intensity: stimulus level
%    response:  subject's response (1:correct, 0:incorrect)
%
% Created by Takehiro Nagai on 12/15/2007

function oq = UpdateNStair(iq,intensity,response)

% error processing
if response~=0 && response~=1
    error('response must be 0 (incorrect) or 1(correct).');
end

if intensity < 1 || intensity > iq.stilevelnum
    error('intensity must be inside the range you set using InitNStair.');
end

oq = iq;

if oq.finishflag    
    fprintf('This staircase has been finished. Thanks.');
    return;
end


% save response data
oq.intensity = [oq.intensity intensity];
oq.response = [oq.response response];
oq.trialnum = oq.trialnum + 1;

nextflag = 0;   % 0:same as current, 1:low level, 2:high level

% determine change direction
if response % correct
    if oq.continuecorrect >= oq.nupdown - 1;
        nextflag = 1;
    end
else        % false
    nextflag = 2;
end

% judge returning
if (nextflag == 1 && oq.lreturn == 2) || (nextflag == 2 && oq.lreturn == 1)
    oq.returnnum = oq.returnnum + 1;
    oq.returnlevel = [oq.returnlevel intensity];
end
if nextflag ~=0
    oq.lreturn = nextflag;
end

% determine next stilevel
if oq.currentlevel > oq.stilevelnum - 1;
    oq.currentlevel = oq.currentlevel - 1;
    oq.continuecorrect = 0;
elseif oq.currentlevel < 2
    oq.currentlevel = 2;
    oq.continuecorrect = 0;
elseif nextflag == 1
    oq.currentlevel = oq.currentlevel - 1;
    oq.continuecorrect = 0;
elseif nextflag == 2
    oq.currentlevel = oq.currentlevel + 1;
    oq.continuecorrect = 0;
else
    oq.continuecorrect = oq.continuecorrect+1;
end

% judge stair finishing
if oq.crikind == 'r'
    if oq.returnnum >= oq.criterion
        oq.finishflag = 1;
    end
else
    if oq.trialnum >= oq.criterion
        oq.finishflag = 1;
    end
end
