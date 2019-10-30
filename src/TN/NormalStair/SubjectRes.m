% ------------------
% SubjectRes (ver.1)
% ------------------
%
% Return ideal subject's response.
%
% How to use: SubjectRes(sti,u,var,nAFC[,noise])
%    sti:   stimulus value
%    u:     mean of subject's psychometric function
%    var:   variance of subject's psychometric function
%    nAFC:  nAFC of experiment (1 for yes/no task)
%    noise: (optional)noise (0~1) added to all stimulus intensities to simulate actual subject's response
% Created by Takehiro Nagai on 12/15/2007

function res = SubjectRes(sti,u,var,nAFC,noise)

if nargin == 4
    noise = 0;
end

if nAFC>1
    chance = 1./nAFC;
    prob = chance + NormalCumulative(sti,u,var).*(1-chance-noise);
else
    prob = NormalCumulative(sti,u,var);
end

intervalue = rand(1);
if intervalue<prob
    res = 1;
else
    res = 0;
end

% fprintf('intervalue = %f, prob = %f\n', intervalue, prob);
