
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

pave = zeros(2:9);
pave = (pa + pb + pc + pd + pe + pf + pg) / 7;

x = [1 2 3 4 5 6 7 8 9];

for i = 1:2
    
    figure;
    % individual
    plot(x,pa(i,:),'--o','Color',[1 0.5 0.5]);
    hold on;
    plot(x,pb(i,:),'--o','Color',[0.75 0.75 0.5]);
    hold on;
    plot(x,pc(i,:),'--o','Color',[0.5 1 0.5]);
    hold on;
    plot(x,pd(i,:),'--o','Color',[0.5 0.75 0.75]);
    hold on;
    plot(x,pe(i,:),'--o','Color',[0.5 0.5 1]);
    hold on;
    plot(x,pf(i,:),'--o','Color',[0.75 0.5 0.75]);
    hold on;
    plot(x,pg(i,:),'--o','Color',[0.9 0.7 0.5]);
    hold on;
    
    % average
    plot(x,pave(i,:),'-o','Color',[0.3 0.3 0.3],'MarkerFaceColor',[0.3 0.3 0.3],'LineWidth',3);
    hold on;
    
    xticklabels({'gray', 'red', 'orange', 'yellow', 'green', 'blue-green', 'cyan', 'blue', 'magenta'});
    xlim([0 10])
    xlabel('色度','FontSize',17);
    ylabel('輝度 (cd/m^2)','FontSize',17);
    
end