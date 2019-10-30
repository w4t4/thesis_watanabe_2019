% SaveExpVariables (ver.1.0)
% 
% Save variables based on file name data created by InitExp
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Usage:
%     SaveExpVariables;
% 
% Input:
%     FileName.vfors:     cell array that containing variable names you want to save
%
% Comment:
%     You must create 'vfors' variables to use this function.
%     1.  vfors = cell(1);
%     2.  vfors = 'FileName'; % first variable
%     3.~ vfors = [vfors, 'variable1', 'variable2'];  % add other variables
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
%     
% Created by Takehiro Nagai on 06/10/2009 (ver.1)
% 

goto = cd;
cd([goto FileName.folder]);

l = length(FileName.vfors);
filenames = [];
for i=1:l
    filenames = [filenames ', ''' FileName.vfors{i} '''']; %#ok<AGROW>
end

eval(['save(''' FileName.fname '.mat''' filenames ')'])

cd ..



