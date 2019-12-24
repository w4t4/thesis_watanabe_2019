close all
%load('mat/luminance.mat');
plot(aveP(1,:),'ro');
xticklabels({'gray', 'red', 'orange', 'yellow', 'green', 'blue green', 'cyan', 'blue', 'mazenta'});
hold on;


figure;
plot(aveP(2,:),'bo');
hold on;
title('6 average')
plot(luminance(1,:));
hold off;