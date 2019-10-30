% OLEDGammaMerge 
% 
% Connecting gamma-curves of ColorCAL and SR-3ARÅD
% Need two files: a .row file from ColorCAL, and the other .csv file made
% (manually) from SR-3AR data.
%
% Some DACs between two files must be overlapped to connect them.
%
% Created by Takehiro Nagai on September 16th 2016.
% Modified by Takehiro Nagai on October 4th 2016. (remove some bugs)
% Modified by Takehiro Nagai on October 5th 2016. (remove some bugs)
%
% 




clear all


%% file-name setting
ccname = input('File name of .row file from ColorCAL? [CC.row]: ', 's');
srname = input('File name of .csv file from SR-3AR? [SR.csv]: ', 's');

if strcmp(ccname,'')
    ccname = 'CC.row';
end

if strcmp(srname,'')
    srname = 'SR.csv';
end


%% Connecting DACs
ap = input('Connecting DAC: input as an array (e.g., [32, 40, 48]) ', 's');
if strcmp(ap,'')
    apoints = [32, 40, 48];
else
    eval(['apoints = ',ap]);
end
% apoints = [24 32]; %%% Important!! Connecting DAC. More higher values such as 64 should be better... %%%
% apoints = [16 24 32];


%% ColorCAL data
load(ccname, '-mat'); % load 'result'

stepnum = size(result, 3);
steps = round(squeeze(result(1,1,:,1))./257);

ccdata_tmp = squeeze(mean(result(:,:,:,2),2))';

% subtract noise in dark measurement
ccdata_tmp(:, 1:3) = ccdata_tmp(:,1:3)-mean(ccdata_tmp(:,4));

% spline to make 256 steps
ccdata = zeros(max(steps)+1,3);
for rgb=1:3
    ccdata(:,rgb)=spline(steps, ccdata_tmp(:,rgb), 0:max(steps));
    ccdata(:,rgb)=MakeMonotonic(ccdata(:,rgb));
end


%% SR3 data
srdata_tmp = load(srname);
srdata = zeros(max(srdata_tmp(:,1))+1, 3);
for rgb=1:3
    srdata(:,rgb)=spline(srdata_tmp(:,1), srdata_tmp(:,rgb+1), 0:max(srdata_tmp(:,1)));
    srdata(:,rgb)=MakeMonotonic(srdata(:,rgb));
end


%% calculate coefficients
ks = zeros(3, length(apoints));
for a=1:length(apoints)
    m = apoints(a)+1;
    % n = find(steps==apoints(a));
    
    for rgb=1:3
        ks(rgb, a) = ccdata(m, rgb)./srdata(m, rgb);
    end
end

k=mean(ks, 2);


%% connect SR-data to ColorCAL-data
r_srdata = [srdata(:,1).*k(1), srdata(:,2).*k(2), srdata(:,3).*k(3)];

maxDAC = length(r_srdata)-1;
srDACs = 0:maxDAC;

%ccDACmaxind = find(steps < maxDAC, 1, 'last' );
ccDACmaxind = maxDAC+1;

DACs = [0:255]' .* 257;
lums = [r_srdata; ccdata(ccDACmaxind+1:end, 1:3)];
data = [DACs lums];

t = clock();
wfn = sprintf('%d%d%d%d%d',t(1),t(2),t(3),t(4),t(5));

% save data, and additional process
save([wfn '.gamb'], 'data', '-ascii', '-tabs');

offn = fitint2voltBits_linux(wfn);



