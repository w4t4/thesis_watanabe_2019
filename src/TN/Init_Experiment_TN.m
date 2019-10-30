% script Init_Experiment_TN.m
% 
% uses namefile.m :
% Polls subject/experimenter for subject initials and condition type and
% creates unique data file name within data folder. Checks for existance of
% data folder and creates if necessary. 
% Creates a global variable DATAFOLDER containing the full path to the data folder.
% Creates a global variable FNAME containing the data file name.
% 
% data folder format:   <mfilename of experiment>_data
% data file format:     <mfilename of experiment>_<subject initials>_<condition>
% 
% uses GetParameterFile.m :
% Needs variables 'ParameterFileName' and 'ParameterFileDate' to exist as
% strings containing the name of the default parameter file and the date
% that file was choosen.  Gives the user the option of accepting that
% parameter file or entering a different one.
% 
% Created: 10-20-2006 T.Czuba UCSD
% Modified: 6-8-2007 T.Nagai UCSD		

global DATAFOLDER;
global FNAME;


fprintf('=========================================================================')
if (proxORcrt=='c')
	fprintf('\nI use a CRT.');
else
	fprintf('\nI use the BIGMAX.');
end
		
GetParameterFile_TN;		%ƒpƒ‰ƒ??[ƒ^ƒtƒ@ƒCƒ‹‚Ì–¼‘Oƒ`ƒFƒbƒN
%fprintf('-------------------------------------------------------------------------\n')

ExpCallerInfo = dbstack;
ParentCaller = ExpCallerInfo(end).name;
		

% run namefile to create a root data file name
[FNAME, fnameinfo] = namefile_TN(ParentCaller); % fnameinfo: file number for the name

% fprintf('-------------------------------------------------------------------------\n')

global DATAFOLDER;
global FNAME;

% display information about the variables/folders that were just created.
fprintf('=========================================================================\n')
fprintf('The global variable "FNAME" has been created containing the data file name.\n')
fprintf('The global variable "DATAFOLDER" has been created containing the full path to the data folder.\n')
fprintf('-------------------------------------------------------------------------\n')
fprintf(['Data folder name:            ', ParentCaller,'_data\n'])
fprintf(['Data file name:              ', FNAME,'\n'])
fprintf('=========================================================================\n\n')


% Make stock sound set in workspace
snd_low = makesnd(200,.1); %makesnd?F‰¹?ì?¬ŠÖ?”?Dˆê‚Â–Ú‚ªŽü”g?”?C“ñ‚Â–Ú‚ªŽ?‘±ŽžŠÔ‚ç‚µ‚¢
snd_lowlong = makesnd(200,.2);
snd_lowshort = makesnd(200,.05);
snd_high = makesnd(1100,.1);
snd_highlong = makesnd(1100,.2);
snd_trial = makesnd(600,.1);
snd_block = makesnd(800,.2);
