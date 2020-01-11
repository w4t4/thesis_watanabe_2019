close all
%load('mat/luminance.mat');
figure('Units','pixels',100);
plot(pa(1,:),'--o','LineWidth',3,'MarkerSize',8,'MarkerFaceColor','[0 0.45 0.73]');
xticklabels({'gray', 'red', 'orange', 'yellow', 'green', 'blue-green', 'cyan', 'blue', 'magenta'});
xlabel('Colors');
ylabel('Luminance(cd/m^2)');
hold on;
title('Subject A');
plot(pa(2,:),'--o','LineWidth',3,'MarkerSize',8,'MarkerFaceColor','[0.85 0.33 0.10]');
legend({'SD着色平均','D着色平均'},'Location','northwest','FontSize',12);
%plot(luminance(1,:));