% Normal Staircase Toolbox
%
% -------------------------------
% Main functions
% -InitNStair:    Use first to initialize staircase.
% -CurrentNStair: Return stimulus level.
% -UpdateNStair:  Update stairase variable based on subject's response and
%                 stimulus level.
% -LogitNStair:   Estimate threshold using 'q.intensity' and 'q.response'
%                 by virtue of 'pfit' function(psignifit).
%
% Sub functions
% -SubjectRes:  Return ideal subject's response for testing of the
%               staircase.
% -NStairDemo:  Demonstration of the staircase.
% -NStairDemo_trial:  Comparison of different threshold estimations using
%                     simulation (under construction)
%
% Future functions
% -MergeNStairData: Collect staircase results of different sessions.
% -MeanNStair:      Estimate threshold using 'q.returnlevel'.
%
% -------------------------------
% How to use:
%  1.Initialize and create staircase variable "q" using "InitNStair".
%  2.Get current stimulus level using "CurrentNStair".
%  3.Get subject's response using the stimulus level above.
%  4.Update the stairecase variable "q" using "UpdateNStair".
%  5.Repeat 2-5 process until the staircase finish.
%  6.Analize the results using 'q.intensity' and 'q.response' like constant
%    stimuli method, or just 'q.returnlevel' by averaging them. 
%
% -------------------------------
% Example:
% q = InitNStair(10,1,2,'r',10);
% flag = 1;
% while flag
%   intensity = CurrentNStair(q);
%   response = SubjectRes(intensity,5,3,2);
%   q = UpdateNStair(q,intensity,response);
%   if q.finishflag
%       flag = 0;
%   end
% end
% threshold = mean(q.returnlevel); 
%
%
%
% Created by Takehiro Nagai on 12/15/2007
%
