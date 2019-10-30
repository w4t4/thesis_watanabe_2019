function t=QuestMean_TN(q)
% t=QuestMean(q)
%
% Get the mean threshold estimate.
% If q is a vector, then the returned t is a vector of the same size.
% 
% See Quest.

% Denis Pelli, 6/8/96
% 3/1/97 dgp updated to use Matlab 5 structs.
% 4/12/99 dgp dropped support for Matlab 4.
% Copyright (c) 1996-2002 Denis Pelli

if nargin~=1
	error('Usage: t=QuestMean(q)')
end
if length(q)>1
	t=zeros(size(q));
	for i=1:length(q(:))
		t(i)=QuestMean(q(i));
	end
	return
end

% original (using QUEST function) version
%t=q.tGuess+sum(q.pdf.*q.x)/sum(q.pdf);	% mean of our pdf

% eliminating the prior version
pdf=exp(-0.5*(q.x/q.tGuessSd).^2);
pdf=q.pdf./pdf;
pdf=pdf/sum(pdf);
t=q.tGuess+sum(pdf.*q.x)/sum(pdf);	% mean of our pdf

