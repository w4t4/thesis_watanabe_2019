load('va.mat');
load('vb.mat');
load('vc.mat');
load('vd.mat');
load('ve.mat');
load('vf.mat');
load('vg.mat');
nv = zeros(9,4,6);
for i = 1:4
    nv(:,i,1) = normalize(va(:,3,i));
end
for i = 1:4
    nv(:,i,2) = normalize(vb(:,3,i));
end
for i = 1:4
    nv(:,i,3) = normalize(vc(:,3,i));
end
for i = 1:4
    nv(:,i,4) = normalize(vd(:,3,i));
end
for i = 1:4
    nv(:,i,5) = normalize(ve(:,3,i));
end
for i = 1:4
    nv(:,i,6) = normalize(vf(:,3,i));
end
for i = 1:4
    nv(:,i,7) = normalize(vg(:,3,i));
end