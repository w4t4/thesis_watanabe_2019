function ps = FCN_PCanalysis_Thurston(mtx, lambda)

stimnum = size(mtx, 1);
ps = zeros(1,stimnum);

for s = 1:stimnum
    ps(s) = mean(TNT_norminv(mtx(s, :).*(1-lambda.*2)+lambda));
end