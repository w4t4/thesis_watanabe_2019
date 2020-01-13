load('va.mat');
load('vb.mat');
load('vc.mat');
load('vd.mat');
load('ve.mat');
load('vf.mat');
load('vg.mat');

vave = zeros(9,4);
vave = (va(:,3,:) + vb(:,3,:) + vc(:,3,:) + vd(:,3,:) + ve(:,3,:) + vf(:,3,:) + vg(:,3,:)) / 7;

sn = [1 2 3 4 5 6 7 8 9];

for i = 1:4
    figure;
    % individual
    errorbar(sn, va(:,3,i), -va(:,1,i), va(:,2,i), '--o','Color',[1 0.5 0.5],'MarkerFaceColor','auto'); % 95%信頼区間
    hold on;
    errorbar(sn, vb(:,3,i), -vb(:,1,i), vb(:,2,i), '--o','Color',[0.75 0.75 0.5],'MarkerFaceColor','auto');
    hold on;
    errorbar(sn, vc(:,3,i), -vc(:,1,i), vc(:,2,i), '--o','Color',[0.5 1 0.5],'MarkerFaceColor','auto');
    hold on;
    errorbar(sn, vd(:,3,i), -vd(:,1,i), vd(:,2,i), '--o','Color',[0.5 0.75 0.75],'MarkerFaceColor','auto');
    hold on;
    errorbar(sn, ve(:,3,i), -ve(:,1,i), ve(:,2,i), '--o','Color',[0.5 0.5 1],'MarkerFaceColor','auto');
    hold on;
    errorbar(sn, vf(:,3,i), -vf(:,1,i), vf(:,2,i), '--o','Color',[0.75 0.5 0.75],'MarkerFaceColor','auto');
    hold on;
    errorbar(sn, vg(:,3,i), -vg(:,1,i), vg(:,2,i), '--o','Color',[0.9 0.7 0.5],'MarkerFaceColor','auto');
    hold on;

    % average
    plot(sn, vave(:,i), '-o','LineWidth',2,'Color',[0.3 0.3 0.3],'MarkerFaceColor',[0.3 0.3 0.3]);
    hold on;

    xticklabels({'gray', 'red', 'orange', 'yellow', 'green', 'blue-green', 'cyan', 'blue', 'magenta'});
    xlabel('色度','FontSize',17)
    xlim([0 10])
    ylabel('選好尺度値','FontSize',17);
    ylim([-5.5 4])
    hold off;
end