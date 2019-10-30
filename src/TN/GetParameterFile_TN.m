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
		
%�p�����[�^���Ƃ��̓�����\��
fprintf(['\nParameter file = ', ParameterFileName,'                     Set on: ', ParameterFileDate,'.\n'])
fprintf('-------------------------------------------------------------------------\n\n')

%�{���͂��̌�Ƀt�@�C����������ŗǂ����ǂ����m�F����̂����A�s�K�v�Ȃ��߂����ł͏ȗ�