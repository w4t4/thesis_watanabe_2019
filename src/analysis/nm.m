load('nv.mat');
load('np.mat');
n = zeros(8,4,7);
for i = 1:8
    for j = 1:4
        for k = 1:7
            n(i,j,k) = nv(i,j,k) - np(i,floor((j+1)/2),k);
        end
    end
end
nave = zeros(8,4);
for i = 1:8
    for j = 1:4
        for k = 1:7
            nave(i,j) = nave(i,j) + n(i,j,k);
        end
        nave(i,j) = nave(i,j)/7;
    end
end

err = zeros(8,2,4);
for i = 1:8
    for j = 1:4
        pd = fitdist(permute(n(i,j,:),[3 2 1]),'Normal');
        pd = paramci(pd);
        err(i,1,j) = pd(1,1);
        err(i,2,j) = pd(2,1);
    end
end
sn = [1 2 3 4 5 6 7 8];
for i = 1:4
    figure;
    for j = 1:7
        plot(sn,n(:,i,j),'--o');
        hold on;
    end
    errorbar(sn,nave(:,i),nave(:,i)-err(:,1,i),err(:,2,i)-nave(:,i),'-o','Color',[0.3 0.3 0.3],'MarkerFaceColor',[0.3 0.3 0.3],'LineWidth',3);
    %plot(sn,nave(:,i),'-o','Color',[0.3 0.3 0.3],'MarkerFaceColor',[0.3 0.3 0.3],'LineWidth',3);
    xticklabels({'red', 'orange', 'yellow', 'green', 'blue-green', 'cyan', 'blue', 'magenta'});
    xlabel('色度','FontSize',17)
    ylabel('光沢感-明るさ感','FontSize',17)
    xlim([0 9])
    ylim([-3 2])
end
