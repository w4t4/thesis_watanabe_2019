load('va.mat');
load('vb.mat');
load('vc.mat');
load('vd.mat');
load('ve.mat');
load('vf.mat');
load('vg.mat');

sn = [1 2 3 4 5 6 7 8 9];

% individual
hold on;
errorbar(sn, va(:,3,1), -va(:,1,1), va(:,2,1), '--o','Color',[1 0.5 0.5],'MarkerFaceColor','auto'); % 95%信頼区間
hold on;
errorbar(sn, vb(:,3,1), -vb(:,1,1), vb(:,2,1), '--o','Color',[0.75 0.75 0.5],'MarkerFaceColor','auto');
hold on;
errorbar(sn, vc(:,3,1), -vc(:,1,1), vc(:,2,1), '--o','Color',[0.5 1 0.5],'MarkerFaceColor','auto');
hold on;
errorbar(sn, vd(:,3,1), -vd(:,1,1), vd(:,2,1), '--o','Color',[0.5 0.75 0.75],'MarkerFaceColor','auto');
hold on;
errorbar(sn, ve(:,3,1), -ve(:,1,1), ve(:,2,1), '--o','Color',[0.5 0.5 1],'MarkerFaceColor','auto');
hold on;
errorbar(sn, vf(:,3,1), -vf(:,1,1), vf(:,2,1), '--o','Color',[0.75 0.5 0.75],'MarkerFaceColor','auto');
hold on;
errorbar(sn, vg(:,3,1), -vg(:,1,1), vg(:,2,1), '--o','Color',[0.9 0.7 0.5],'MarkerFaceColor','auto');
hold on;

% average
%errorbar(sn, va(:,3,1), -va(:,1,1), va(:,2,1), '--ok');
%hold on;

xticklabels({'gray', 'red', 'orange', 'yellow', 'green', 'blue-green', 'cyan', 'blue', 'magenta'});
xlabel('色度','FontSize',17)
xlim([0 9])
ylabel('選好尺度値','FontSize',17);
%ylim([-2.3 2.5])
ylim([-3.3 3.3])
%plot(sn, estimated_sv, 'ok');