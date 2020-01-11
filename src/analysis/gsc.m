for i = 1:7
    gscatter(np(:,1,i),nv(:,1,i))
    hold on
end
figure;
for i = 1:7
    gscatter(np(:,2,i),nv(:,2,i))
    hold on
end
figure;
for i = 1:7
    gscatter(np(:,1,i),nv(:,3,i))
    hold on
end
figure;
for i = 1:7
    gscatter(np(:,1,i),nv(:,4,i))
    hold on
end