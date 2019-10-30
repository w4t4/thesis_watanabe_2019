clear all;

fn=input('Input data file name without extension:','s');

para=load([fn '.ilp'],'-ascii');
iLUT=load([fn '.ilut'],'-ascii');
LUT=load([fn '.lut'],'-ascii');

base=2;

for i=1:10
    x = linspace(0,1,base.^i);
    rgb = [x;x;x]';

    for j=1:100
        tic;
        RGB_LUT = rgb2RGB_LUT(rgb, LUT);
        timer(1,j)=toc;
         %fprintf('Normal LUT:%f sec\n',t);

        tic;
        RGB_iLUT = rgb2RGB_iLUT(rgb,iLUT);
        timer(2,j)=toc;
        %fprintf('Inverse LUT:%f sec\n',t);

        tic;
        RGB_fitting=rgb2RGB_fitting(rgb,para);
        timer(3,j)=toc;
        %fprintf('Computation from fitting function:%f sec\n',t);
    end

    results(i,1)=base.^i;
    results(i,2)=mean(timer(1,:));
    results(i,3)=mean(timer(2,:));
    results(i,4)=mean(timer(3,:));
    
end

figure
plot(results(:,1),results(:,2),'r',results(:,1),results(:,3),'g',results(:,1),results(:,4),'b');
legend('LUT','iLUT','Fitting');

figure
%plot(x,RGB_fitting(:,1),'r', x,RGB_LUT(;,1),'g', x,RGB_iLUT(:,1),'b')
plot(x,RGB_LUT(:,1),'r',x,   RGB_iLUT(:,1),'g',   x,RGB_fitting(:,1),'b');
legend('LUT','iLUT','Fitting');

difference = abs(RGB_LUT-RGB_iLUT);
figure;
plot(x,difference);
