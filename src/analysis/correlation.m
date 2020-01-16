load('np.mat');
load('nv.mat');
load('../mat/mc.mat');
c = mc;
c(:,1,:) = [];

for i = 1:4
    figure;
    for j = 1:8
        scatter(np(j,mod(i-1,2)+1,:),nv(j,i,:),[],'MarkerFaceColor',c(:,j,mod(i-1,2)+1)'/255);
        xlabel('明るさ');
        ylabel('光沢感')
        hold on
    end
    hold off
end