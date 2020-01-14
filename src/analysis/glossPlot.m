load('va.mat');
load('vb.mat');
load('vc.mat');
load('vd.mat');
load('ve.mat');
load('vf.mat');
load('vg.mat');

%vave = zeros(9,4);
%vave = (va(:,3,:) + vb(:,3,:) + vc(:,3,:) + vd(:,3,:) + ve(:,3,:) + vf(:,3,:) + vg(:,3,:)) / 7;

sn = [1 2 3 4 5 6 7 8 9];

for i = 1:4
    figure;
    % individual
    plot(sn, va(:,3,i), '--o','Color',[1 0.5 0.5],'MarkerFaceColor','auto'); % 95%信頼区間
    hold on;
    plot(sn, vb(:,3,i), '--o','Color',[0.75 0.75 0.5],'MarkerFaceColor','auto');
    hold on;
    plot(sn, vc(:,3,i), '--o','Color',[0.5 1 0.5],'MarkerFaceColor','auto');
    hold on;
    plot(sn, vd(:,3,i), '--o','Color',[0.5 0.75 0.75],'MarkerFaceColor','auto');
    hold on;
    plot(sn, ve(:,3,i), '--o','Color',[0.5 0.5 1],'MarkerFaceColor','auto');
    hold on;
    plot(sn, vf(:,3,i), '--o','Color',[0.75 0.5 0.75],'MarkerFaceColor','auto');
    hold on;
    plot(sn, vg(:,3,i), '--o','Color',[0.9 0.7 0.5],'MarkerFaceColor','auto');
    hold on;

    % average
    errorbar(sn,vave(:,3,i), -vave(:,1,i), vave(:,2,i), '-o','LineWidth',2,'Color',[0.3 0.3 0.3],'MarkerFaceColor',[0.3 0.3 0.3]);
    hold on;

    xticklabels({'gray', 'red', 'orange', 'yellow', 'green', 'blue-green', 'cyan', 'blue', 'magenta'});
    xlabel('色度','FontSize',17)
    xlim([0 10])
    ylabel('選好尺度値','FontSize',17);
    ylim([-5.5 4])
    hold off;
end