% ------------------
% LogitNStair (ver.1)
% ------------------
%
% Threshold estimation by logistic analysis. It is recommended that
% 'q'(staircase variable) is merged between different sessions to estimate
% threshold more accurately.
% 
%
% How to use: [threshold SE forlog params] = LogitNStair(q, minv, maxv, n_intervals[, lambda][, plot])
%  Input 
%    q:            Staircase variable
%    minv:         Minimum stimulus value corresponding to 1 stimulus level
%    maxv:         Maximum stimulus value corresponding to stilevelnum stimulus
%                  level.
%    n_intervals:  "n"AFC experiment. 1 for yes/no experiment.
%    lambda:       (optional)lambda used for threshold estimation. Small
%                  lambda such as '0.01' could reduce bias of slope estimation.
%                   default value is 0. 
%    plot:         (optional)1:plot fitting chart (default), 0:not plot it.
%
%  Output
%    threshold:   Estimated threshold.
%    SE:          Asymptotic standard error of the threshold.
%    forlog:      Data for logistic analysis by pfit function.
%    params:      Parameters of a fitted psychometric function (this can be used in the plotpf function to plot a psychometric function)
%
% Created by Takehiro Nagai on 12/15/2007
%

function [threshold SE forlog params] = LogitNStair(q,minv,maxv,n_intervals,lambda,plot)

if nargin < 4
    error('Usage:LogitNStair(q,minv,maxv,n_intervals[,plot])');
elseif nargin == 4
    lambda = 0;
    plot = 1;
elseif nargin == 5
    plot = 1;
end

% transform data
xvals = linspace(minv,maxv,q.stilevelnum);

trialnums = zeros(q.stilevelnum,1);
correctnums = zeros(q.stilevelnum,1);
forlog = [];

for i=1:q.stilevelnum
    yn = q.intensity == i;
    trialnums(i) = sum(yn);
    correctnums(i) = sum(yn.*q.response);
    if trialnums(i)>0
        forlog = [forlog; xvals(i) correctnums(i)./trialnums(i) trialnums(i)];
    end
end


% logistic analysis
if n_intervals == 1
    gamma = 0;
else
    gamma = 1./n_intervals;
end
if plot
    result = pfit(forlog,'plot','n_intervals', n_intervals,'runs', 2,'FIX_GAMMA',gamma,'FIX_LAMBDA',lambda,'verbose','false');
else
    result = pfit(forlog,'no plot','n_intervals', n_intervals,'runs', 2,'FIX_GAMMA',gamma,'FIX_LAMBDA',lambda,'verbose','false');
end

threshold = result.thresholds.est(2);
varcovar = inv(result.fisher);
SE = sqrt(varcovar(1,1));
params = result.params.est;
