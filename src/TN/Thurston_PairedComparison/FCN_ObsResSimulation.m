function [mtx, OutOfNum, NumGreater] = FCN_ObsResSimulation(sv, cmbs, tnum, sd)

stimnum = length(sv);
msd = sd./sqrt(2);
combinum = size(cmbs, 1);

mtx = zeros(stimnum, stimnum);
NumGreater = zeros(stimnum, stimnum);
OutOfNum = zeros(stimnum, stimnum);
for c=1:combinum
    s1=cmbs(c,1);
    s2=cmbs(c,2);
    
    r1 = randn(tnum,1).*msd+sv(s1);
    r2 = randn(tnum,1).*msd+sv(s2);
    
    mtx(s1,s2) = sum((r1-r2)>0)./tnum;
    mtx(s2,s1) = 1-mtx(s1,s2);
    
    OutOfNum(s1,s2) = tnum;
    OutOfNum(s2,s1) = tnum;
    NumGreater(s1,s2) = sum((r1-r2)>0);
    NumGreater(s2,s1) = sum((r1-r2)<=0);
    
    if NumGreater(s1,s2)+NumGreater(s2,s1)~=tnum
        error('something has happned...');
    end
end

for s = 1:stimnum
    mtx(s, s) = 0.5;
end

