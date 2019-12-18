%load('mat/luminance.mat');
plot(patch(1,:));
hold on;
xlabel = ['red' 'orange' 'yellow' 'yellow green' 'green' 'blue green' 'cyan' 'blue' 'mazenta'];

plot(patch(2,:));
hold on;
title('4 average')
plot(luminance(1,:));
legend({'SD','D','refLum'},'Location','northwest')
hold off;