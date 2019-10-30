% ------------------
% NStairDemo (ver.1)
% ------------------
%
% Demonstration of Normal Staircase
%
% Created by Takehiro Nagai on 12/15/2007

function NStairDemo()

% staircase parameter
stilevel = 10;
startlevel = 1;
ndown = 2;

% subject's parameter
u = 5;
var = 3;
nAFC = 2;

rand('state',sum(100*clock));

% staircase process
q = InitNStair(stilevel, startlevel, ndown, 'r', 1000);
flag = 1;
while flag
  intensity = CurrentNStair(q);
  response = SubjectRes(intensity,u,var,nAFC);
  q = UpdateNStair(q,intensity,response);
  if q.finishflag
      flag = 0;
  end
end
threshold = mean(q.returnlevel);

% output result
fprintf('Estimated threshold is %f\n',threshold);

figure
plot(q.intensity)
