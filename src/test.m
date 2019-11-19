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
% 
% figure;
% plot(abs(monitorColorMax(:,1,8)-upvplWhitePoints(:,1)),'b');
% hold on;
% plot(abs(monitorColorMax(:,2,8)-upvplWhitePoints(:,2)),'r');
% hold off;

fixedColorMax = zeros(size(monitorColorMax));
for i = 1:8
    for j = 1:2
        fixedColorMax(:,j,i) = monitorColorMax(:,j,i)-upvplWhitePoints(:,j);
    end
end
fixedColorMax(:,3,:) = monitorColorMax(:,3,:);
for i = 114:200
    for j = 1:8
        for k = 1:2
            fixedColorMax(i,k,j) = fixedColorMax(i,k,j)*abs(monitorColorMax(i,2,7)-upvplWhitePoints(i,2))/bMaxSaturation;
        end
    end
end

figure;
for i = 1:2
    for j = 1:8
        plot(fixedColorMax(:,i,j));
        hold on;
    end
    hold off;
    figure;
end

save('mat/fixedColorMax.mat','fixedColorMax');

% figure;
% plot(fixedColorMax(:,1,1),'r');
    %114 115
