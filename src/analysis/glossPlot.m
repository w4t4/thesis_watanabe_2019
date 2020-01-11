%figure('Position',[1 1 800 300], 'Name', 'Ground truth vs Estimated')
sn = [1 2 3 4 5 6 7 8 9];
hold on;
errorbar(sn, va(:,3,1), -va(:,1,1), va(:,2,1), '--ok'); % 95%信頼区間
hold on;
title('Subject A, Dragon,SD')
xticklabels({'gray', 'red', 'orange', 'yellow', 'green', 'blue-green', 'cyan', 'blue', 'magenta'});
xlabel('Colors')
xlim([0 9])
ylabel('選好尺度値');
%ylim([-2.3 2.5])
ylim([-3 2.5])
%plot(sn, estimated_sv, 'ok');