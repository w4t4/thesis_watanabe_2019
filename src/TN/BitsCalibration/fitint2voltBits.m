% fitint2voltBits ver1.0
%
% Compute LUT, inverse LUT, and parameters of fitted inverse gamma function
% against measured CRT gamma characteristic.
%
% Usage: fitint2voltBits(ifn)
% ifn: name of gamma characteristic file without extension '.gamb'.
% The file can be created by 'udtmeasBitsPTB3.m'.
%
% Created by Takehiro Nagai on July 2nd 2007


function offn = fitint2voltBits(ifn)

fdata = load([ifn '.gamb'],'-ascii');
glength = size(fdata,1);


% digital output value
dvalueori = fdata(:,1);
NormDvalue = (dvalueori)./65535;

% monitor intensity
gamma = fdata(:,2:4)-repmat(fdata(1,2:4),[glength 1]);  % subtract dark gamma for each gun
for gun=1:3;    gamma(:,gun)=gamma(:,gun)./max(gamma(:,gun));   end; % normalization by maximum value(0~1)

% output values of Bits++
dvalues = 1:65536;
NormDvalues = (dvalues-1)./65535;




%---- Method1: fit gamma function to CRT intensity profiles ----
figure; hold on;
graphr = 100;
para = zeros(4,3);
results = zeros(graphr,3);
for gun=1:3
    x = [0 2.2];    %initial value
    x = fminsearch(@(z)rmseGF(z,0,1,NormDvalue,gamma(:,gun)), x);   %fitting
    para(1,gun)=0;
    para(2,gun)=1;
    para(3,gun)=x(1);
    para(4,gun)=x(2);
  
    
    % plot graph
    temp = linspace(0,1,graphr);
    results(:,gun) = gammac(temp,para(:,gun));
    if gun==1;   plot(NormDvalue,gamma(:,gun), 'ro', temp, results(:,gun),'r');
    elseif gun==2; plot(NormDvalue,gamma(:,gun), 'go', temp, results(:,gun),'g');
    elseif gun==3; plot(NormDvalue,gamma(:,gun), 'bo', temp, results(:,gun),'b');
    end;
        
    % compute inverse function
    temp = linspace(0,1,graphr);
    results(:,gun) = gammacinv(temp,para(:,gun));
end
hold off;
title('Measured Data and Fitted Gamma Function');
xlabel('Normalized DAC of Bits++');
ylabel('Normalized intensity')

% save fitted gamma function parameters
ofn=ifn;
i=1;
while fopen([ofn '.ilp']) ~= -1 % If a file of the name has already existed.
   fclose('all');
   nums = num2str(i);
   ofn=[ifn '[' nums ']'];
   i=i+1;
end
eval(['save ' [ofn '.ilp'] ' para -ASCII -DOUBLE -TABS'])
fprintf('A ILP file "%s" was created for "rgb2RGB_fitting".\n',[ofn '.ilp']);
ofn1 = sprintf('A ILP file "%s" was created for "rgb2RGB_fitting".\n',[ofn '.ilp']);

% plot inverse function
% figure;
% plot(temp, results(:,1),'r', temp, results(:,2),'g', temp, results(:,3),'b');
% title('Inverse fitted gamma function');




%---- Method2: Spline Interpolation ----
smoothedintensity=zeros(65536,3);
for gun=1:3
    
    fit_out = FitGammaSpline(NormDvalue, gamma(:,gun), NormDvalues);
    smoothedintensity(:,gun)=fit_out;
    
%     % check whether data is monotonically increasing
%     difference = gamma(2:glength,gun) - gamma(1:glength-1,gun);
%     mi=min(difference);
%     
%     % if the data is not monotonically increasing, fit gamma function to the
%     % range that is not monotonically increasing
%     if mi<0 
%         for i=glength-1:-1:1    % find the maximum index that is not monotomically increasing
%             if difference(i)<0; index=i;    break;  end;   
%             index2 = min([i.*3 glength]);   % the range to 3 times the maximum index will be smoothed
%         end
% 
%             % gamma function fitting
%         x = [0 max(gamma(1:index2,gun)) 0 2.2];    % initial parameters (k,Lm,j0,g)
%         drange = (1:index2)./index2;      % value of functional horizontal axis
%         [x,fval,exitflag] = fminsearch(@(z)rmseGF2(z,drange,gamma(1:index2,gun)), x);
%         
%         if exitflag<0   % interpolate linearly if the gamma function fitting was failed
%             gamma(1:index2,gun) = interp1([1,index2], [gamma(1,gun) gamma(index2,gun)], drange, 'linear');
%         else % replace the values with those estimated from fitted gamma function
%             gamma(1:index2,gun) = gammac(drange,x);
%         end
%     end
%     
%     
%     % spline interpolation
%     smoothedintensity(:,gun) = interp1(dvalueori, gamma(:,gun), dvalues, 'spline');
%     smoothedintensity(1,:) = 0; % minimum value = 0
%     smoothedintensity(65536,:) = 1; % maximum value = 0
% 
%     % all of the data must be over 0
%     for i=1:65536
%         if smoothedintensity(i,gun)<0;   smoothedintensity(i,gun)=0; end;
%     end    
%         
%     % monotomically increasing check
%     difference = (smoothedintensity(2:65536,gun) - smoothedintensity(1:65535,gun));
%     mi=min(difference);
%     if mi<0 % interpolate linear ly if the data is not monotomically increasing
%         for i=65535:-1:1;
%             if difference(i)<0; 
%                 index = i+2;    % maximum index which is not monotomically increasing.
%                 break;
%             end;
%         end
%         % linear interpolation
%         smoothedintensity(1:index,gun)=interp1([1 index],[smoothedintensity(1,gun) smoothedintensity(index,gun)], 1:index,'linear');
%     end;    
end

smoothedintensity=MakeMonotonic(smoothedintensity);

for gun=1:3
    smoothedintensity(:,gun)=smoothedintensity(:,gun)./smoothedintensity(65536,gun);
end

% make inverse LUT from spline fit
rgb = [NormDvalues; NormDvalues; NormDvalues]';
RGB = rgb2RGB_LUT(rgb, smoothedintensity);

% graph plot
figure
plot(rgb(:,1),RGB(:,1),'r',rgb(:,2),RGB(:,2),'g',rgb(:,3),RGB(:,3),'b');
xlabel('Desired normalized intensity');
ylabel('DAC of Bits++')
title('Inverse LUT');

% save LUT
ofn=ifn;
i=1;
while fopen([ofn '.lut']) ~= -1 % if a file of the name has already existed.
   fclose('all');
   nums = num2str(i);
   ofn=[ifn '[' nums ']'];
   i=i+1;
end
eval(['save ' [ofn '.lut'] ' smoothedintensity -ASCII -DOUBLE -TABS'])
fprintf('A LUT file "%s" was created for "rgb2RGB_LUT".\n',[ofn '.lut']);
ofn2 = sprintf('A LUT file "%s" was created for "rgb2RGB_LUT".\n',[ofn '.lut']);

% save inverse LUT
ofn=ifn;
i=1;
while fopen([ofn '.ilut']) ~= -1 % if a file of the name has already existed.
   fclose('all');
   nums = num2str(i);
   ofn=[ifn '[' nums ']'];
   i=i+1;
end
eval(['save ' [ofn '.ilut'] ' RGB -ASCII -DOUBLE -TABS'])
fprintf('A ILUT file "%s" was created for "rgb2RGB_iLUT".\n',[ofn '.ilut']);
ofn3 = sprintf('A ILUT file "%s" was created for "rgb2RGB_iLUT".\n',[ofn '.ilut']);


% full file name
offn = cell(3,1);
offn{1} = ofn1;
offn{2} = ofn2;
offn{3} = ofn3;


