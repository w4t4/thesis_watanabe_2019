% inverts gamma table normal graphic card.
% [InvGammaTable] = makeInvGamma(filename)
% filename is the .gam file measured with UDTmeasPTB 
%

function [InvGammaTable] = makeInvGamma(filename)

load(filename,'-mat'); % iiyama_1280x1024_20070504.gam;
GammaTable = data;  % GammaTable is a (256,4) matrix with [0:255, R , G , B]
precision = size(GammaTable,1);  % e. g. for 8 Bit card 256 values 

% *******************************************************
% make the data monotonic:
%--------------------------------------------------------
        GammaTableUP = GammaTable;
        GammaTableDOWN = GammaTable;
        % make monotonic
        for i=1:3
            %GammaTable(:,i) = cumsum([intensity(1,i); max(0,diff(intensity(:,i),1,1))],1);
            n=2; numChanged=0;
            while n <= size(GammaTable,1)
                if GammaTableUP(n,i) < GammaTableUP(n-1,i)
                    GammaTableUP(n,i) = GammaTableUP(n-1,i); 
                    numChanged=numChanged+1;
                end
                n = n + 1;
            end
            n=size(GammaTable,1); 
            while n >= 2
                if GammaTableDOWN(n-1,i) > GammaTableDOWN(n,i)
                    GammaTableDOWN(n-1,i) = GammaTableDOWN(n,i);
                    numChanged=numChanged+1;
                end
                n = n - 1;
            end
        end
        GammaTable = (GammaTableUP+GammaTableDOWN)./2;
        disp('If intensity(n)<intensity(n-1), intensity(n) and intensity(n-1)')
        disp('are set to (intensity(n)+intensity(n-1))/2, for all n ...')
        fprintf('\n%d datapoints were changed\n\n',numChanged)

% *******************************************************
% normalize smoothed intensity measurements to highest R, G, B 
% values measured  between 0 and precision
%--------------------------------------------------------

% GammaTable = [dacvalue redintensity greenintensity blueintensity]
GammaTable(:, 2) = (precision-1) .* GammaTable(:, 2)./max(GammaTable(:, 2));
GammaTable(:, 3) = (precision-1) .* GammaTable(:, 3)./max(GammaTable(:, 3));
GammaTable(:, 4) = (precision-1) .* GammaTable(:, 4)./max(GammaTable(:, 4));
%figure; plot(GammaTable(:, 2));

disp('...');

% *******************************************************
%look up dacvalue needed to produce each desired intensity
%--------------------------------------------------------

for gun=1:3 % red, green, blue
   for desint=0:(precision-1)	% look for an exact match /  desint = desired intensities
      exactindex = find(abs(GammaTable(:,gun+1)-desint)<1e-12);
      if ~isempty(exactindex) % if exact match was found
         InvGammaTable(desint+1, gun) = exactindex(1);
      else  % otherwise interpolate
         % finding indices within GammaTable which are close to desint
	    lowerindex = max(find(GammaTable(:,gun+1)<desint));
   	    higherindex = min(find(GammaTable(:,gun+1)>desint));
      	if ~isempty(lowerindex) & ~isempty(higherindex) % if there is a lower and a higher index available
         	fractionhigher = (desint-GammaTable(lowerindex,gun+1))...
            	              ./(GammaTable(higherindex,gun+1)-GammaTable(lowerindex,gun+1));
	        InvGammaTable(desint+1,gun) = fractionhigher .* (higherindex-lowerindex) + lowerindex;  
	    elseif isempty(lowerindex) % if there is no lower or higher index (at the ends of the gamma table)
   	      fractionhigher = desint./GammaTable(higherindex,gun+1);
      	  InvGammaTable(desint+1,gun) = fractionhigher .* (higherindex-1)+ 1;
	    elseif isempty(higherindex)
   	      InvGammaTable(desint+1,gun) = max(size(GammaTable,1));
        end
      end
   end
end
InvGammaTable = InvGammaTable-1; % to get dac Values in the gamma table between 0 and 255, which are used as indices)
figure; plot(InvGammaTable(:, 2));
InvGammaTable10bit = InvGammaTable;
% *******************************************************
%scaling of the InvGammaTable between 0 and 1
%--------------------------------------------------------
InvGammaTable = InvGammaTable./(precision-1);
save([filename(1:end-4) '.lut'],'InvGammaTable')

figure;
% plot(GammaTable(:,1), GammaTable(:,2), 'r', GammaTable(:,1), InvGammaTable(:,2), 'r--');
plot( InvGammaTable(:,2), 'r.');
%plot( diff(InvGammaTable(:,2)), 'r.');


% % *******************************************************
% %scaling of the InvGammaTable between 0 and 1 with precision of 10 bits,
% %use only the first quarter of the range 
% %--------------------------------------------------------
% InvGammaTable10bit = InvGammaTable10bit./(1024-1);
% InvGammaTable10bit(precision,:) = 1; 
% save([filename(1:end-4) '10bit.lut'],'InvGammaTable10bit')
% 
% figure;
% % plot(GammaTable(:,1), GammaTable(:,2), 'r', GammaTable(:,1), InvGammaTable(:,2), 'r--');
% plot( InvGammaTable10bit(:,2), 'b.');
% %plot( diff(InvGammaTable10bit(:,2)), 'b.');


% % Test whether the tables are proper inverses.  Make some linear intensity values.
% *************************************************************************
%  light = rand(5,3);
%  digital = rgb2dac(light,invGamma);
%  light2 = dac2rgb(digital,gamma);
%  percentError = 100* (light2 - light) ./ light
% 
%  If we repeat the process, we avoid the imperfections of the discrete set
%  of look up table levels. The inversion is then perfect.  
% 
%  digital2 = rgb2dac(light2,invGamma)
%  light3 = dac2rgb(digital2,gamma)
%  light3 - light2
