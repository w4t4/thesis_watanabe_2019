%load('mat/luminance.mat');
plot(a(1,:));
hold on;
plot(a(2,:));
hold on;
title('NAll')
plot(luminance(1,:));
legend({'SD','D','refLum'},'Location','northwest')
hold off;