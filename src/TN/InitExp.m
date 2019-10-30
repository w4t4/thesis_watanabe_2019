% InitExp (ver.1.0)
% 
% Initialize folder and file name for saving data.
% Also, this function checks how many sessions with the same experimental
% parameters were conducted.
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Usage:
%     FileName = InitExp(ini,cond);
% 
% Input:
%     ini:  subject's initial (str)
%     cond: condition name (str)
%
% Output:
%     FileName.folder: folder name of data
%     FileName.fname:  name of data file
%     FileName.info:   session # in the same condition
%     FileName.parent: function name that started the current experiment
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
%     
% Created by Takehiro Nagai on 06/10/2009 (ver.1)
% 

function FileName = InitExp(ini,cond)

% check the script name running this session
ExpCallerInfo = dbstack;
ParentCaller = ExpCallerInfo(end).name;
FileName.parent = ParentCaller;
		
% base file name and folder name for data
filename = [ParentCaller,'_',ini,'_',cond];
foldername = ['\',ParentCaller,'_data','\'];

if isempty(cond)	% adjust file name when cond is null
    filename = filename(1:end-1);
end

% Check if there is the data folder
goto = cd;  % current directory
if exist([goto foldername] ,'dir')==0;	% create data folder if there is not.
    mkdir ([goto foldername]);    
    fprintf('%s folder created.\n', foldername);	 
end

%Check if file already exists, if so append session name.
cd([goto foldername]);	
found = 0;
loc = 2;
while found ~= 1
    if exist([filename '.mat'],'file')~=0
        num2str(loc);
        filename = [ParentCaller,'_',ini,'_',cond,'(',num2str(loc),')'];
        found = 0;
        loc = loc+1;
    elseif exist([filename '.mat'],'file')==0;
        found = 1;
        info = loc-1;
    end
end
cd .. 

% [fname, fnameinfo] = namefile_TN(ParentCaller); % fnameinfo: file number for the name

% display information about the variables/folders that were just created.
fprintf('=========================================================================\n')
fprintf(['Data folder name:            ', ParentCaller,'_data\n'])
fprintf(['Data file name:              ', filename,'\n'])
fprintf('=========================================================================\n\n')

% output
FileName.folder = foldername;
FileName.fname = filename;
FileName.info = info;
