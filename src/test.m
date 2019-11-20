% b = zeros(720,960,3,9);
% for i = 1:1
%     a = wtXYZ2rgb(wtTonemap(xyzSD(:,:,:)),ccmatrix);
%     wtColorCheck(a);
%     b(:,:,:,i) = a;
%     %figure;
%     %imshow(a);
% end
% figure;
% montage(b, 'size', [1 1]);

load('mat/monitorColorMax.mat');
figure;
plot(monitorColorMax(:,1,1)-upvplWhitePoints(:,1),'r');
hold on;
plot(abs(monitorColorMax(:,2,3)-upvplWhitePoints(:,2)),'y');
hold on;
plot(abs(monitorColorMax(:,1,5)-upvplWhitePoints(:,1)),'g');
hold on;
plot(abs(monitorColorMax(:,2,7)-upvplWhitePoints(:,2)),'b');
hold off;
bMaxSaturation = max(abs(monitorColorMax(:,2,7)-upvplWhitePoints(:,2)))
 
% for i = 1:2
%     figure;
%     for j = 1:8
%         plot(monitorColorMax(:,i,j)-upvplWhitePoints(:,i));
%         hold on;
%     end
%     hold off;   
% end


fixedColorMax = monitorColorMax;
for i = 1:8
    for j = 1:2
        fixedColorMax(:,j,i) = monitorColorMax(:,j,i)-upvplWhitePoints(:,j);
    end
end

for i = 114:200
    for j = 1:8
        for k = 1:2
            fixedColorMax(i,k,j) = fixedColorMax(114,k,j)*abs(monitorColorMax(i,2,7)-upvplWhitePoints(i,2))/bMaxSaturation;
        end
    end
end

for i = 1:2
    figure;
    for j = 1:8
        plot(fixedColorMax(:,i,j));
        hold on;
    end
    hold off;   
end

save('mat/fixedColorMax.mat','fixedColorMax');

% figure;
% plot(fixedColorMax(:,1,1),'r');
    %114 115
