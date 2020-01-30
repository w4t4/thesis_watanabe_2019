n = zeros(8,4,7);
for i = 1:8
    for j = 1:4
        for k = 1:7
            n(i,j,k) = nv(i,j,k) - np(i,floor((j+1)/2),k);
        end
    end
end

figure;
sn = [1 2 3 4 5 6 7 8];
for j = 1:7
    plot(sn,n(:,1,j),'--o');
    hold on;
end
xticklabels({'red', 'orange', 'yellow', 'green', 'blue-green', 'cyan', 'blue', 'magenta'});
xlabel('色度','FontSize',17)
xlim([0 9])