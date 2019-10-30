% script GetParameterFile_TN.m
%       -For use with Init_Experiment.m
% 
% Shows the current default parameter file name and date it was set as default.
% Asks if you want to use it or choose a different file.
% 
% *****Needs input variables 'ParameterFileName' and 'ParameterFileDate' to
% already exist in the workspace.*****
% 
% Created: 10-19-2006 T.Czuba UCSD
% Modified: 6-8-2007 T.Nagai UCSD
		
%パラメータ名とその日時を表示
fprintf(['\nParameter file = ', ParameterFileName,'                     Set on: ', ParameterFileDate,'.\n'])
fprintf('-------------------------------------------------------------------------\n\n')

%本当はこの後にファイル名がこれで良いかどうか確認するのだが、不必要なためここでは省略