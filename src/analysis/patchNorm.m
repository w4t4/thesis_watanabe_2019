
% load patch data
load('../../data/patch/hf_2019-12-18T144358.mat');
pa = patchData;
load('../../data/patch/ir_2019-12-24T165755.mat');
pb = patchData;
load('../../data/patch/mh_2019-12-23T184040.mat');
pc = patchData;
load('../../data/patch/mk_2019-12-04T164144.mat');
pd = patchData;
load('../../data/patch/ot_2019-12-11T155149.mat');
pe = patchData;
load('../../data/patch/sa_2019-12-12T144844.mat');
pf = patchData;
load('../../data/patch/sy_2019-12-11T171754.mat');
pg = patchData;

np = zeros(9,2,7);
np(:,1,1) = normalize(transpose(pa(1,:)));
np(:,2,1) = normalize(transpose(pa(2,:)));
np(:,1,2) = normalize(transpose(pb(1,:)));
np(:,2,2) = normalize(transpose(pb(2,:)));
np(:,1,3) = normalize(transpose(pc(1,:)));
np(:,2,3) = normalize(transpose(pc(2,:)));
np(:,1,4) = normalize(transpose(pd(1,:)));
np(:,2,4) = normalize(transpose(pd(2,:)));
np(:,1,5) = normalize(transpose(pe(1,:)));
np(:,2,5) = normalize(transpose(pe(2,:)));
np(:,1,6) = normalize(transpose(pf(1,:)));
np(:,2,6) = normalize(transpose(pf(2,:)));
np(:,1,7) = normalize(transpose(pg(1,:)));
np(:,2,7) = normalize(transpose(pg(2,:)));