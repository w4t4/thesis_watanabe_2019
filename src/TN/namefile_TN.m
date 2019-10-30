function [filename, info] = namefile(expname,ini,cond)

% function [filename, info]= namefile(expname,ini,cond)
% 
% [expname]= name of mfile calling this function. Use "mfilename" to auto insert parent file name.
% [ini]= subject initials
% [cond]= condition name 
% 
% TO ADD TO EXISTING CODE:
%   Place 'namefile' in matlab path, and insert the line:
%           filename = namefile(mfilename);
%   at top of original code.
% 
% Creates variable called 'filename' which stores the subject's initials,
% the experiment name, and the condition.
% 
% 'filename' will be used by 'smartsave' function to create a data file.
%
% September 27, 2006 T. Czuba UCSD

global SUBJECT_NAME;

fprintf('\n');
		
%{
%get subject initials and error check
s = 0;
while s ~= 1
    ini = input('Please input subject initials: ','s');	%�팱�҂̃C�j�V�������󂯎��
    if isempty(ini)==1
        disp('Error:  Subject initials are needed.');
        s = 0;
        
    elseif isempty(ini)==0
        s = 1;
    end
end

fprintf('\n');
%}

ini=SUBJECT_NAME;

%{
%Get name for condition and error check %���ꂪ�悭������܂���
cond = input('Please input condition abreviation(leave blank if none exists): ','s');
if isempty(cond)==1
    cond = [];
end
%}

cond = [];

%Create name variable for 'smartsave' %����܂ł̓��͓��e����t�@�C�����ƃt�H���_�������
filename = [expname,'_',ini,'_',cond];
foldername = ['\',expname,'_data','\'];%Win��Mac�̈Ⴂ�������Ȃ������̂ŕ�?X

if isempty(cond)	%?��?���������Ƃ�?A�ꕶ���]��̂������?߂��Ă���
    filename = filename(1:end-1);
end


%Set current directory	%��?݂̃f�B���N�g������
goto = cd;

foldername2=foldername(2:end-1); %Win��Mac�̈Ⴂ�������Ȃ������̂�?�?�?D�����t�@�C�����w����@�ɈႢ�����邱�Ƃ�����?D

if exist([goto foldername] ,'dir')==0;	%��?݂̃f�B���N�g���ȉ��Ƀf?[�^���̓t�H���_�����邩�Ȃ����𔻒f��?A�Ȃ���΃t�H���_?�?�
		mkdir (foldername2); %Win��Mac�̈Ⴂ�������Ȃ������̂ŕ�?X
end

cd([goto foldername]);	%�f�B���N�g���ړ�

global DATAFOLDER	%�O�??[�o����?�?錾
DATAFOLDER = [goto foldername];	%�f?[�^�t�H���_�����?��Ɋi�[

%Check if file already exists, if so append session name.	%�t�@�C������?d�Ȃ�������?�?������Ȃ��悤�Ƀt�@�C�������?X����炵��?D
found = 0;
loc = 2;
while found ~= 1
    if exist([filename '.mat'],'file')~=0 | exist([filename '_tempwkspc.mat'],'file')~=0,
        num2str(loc);
        filename = [expname,'_',ini,'(',num2str(loc),')','_',cond];
        found = 0;
        loc = loc+1;
    elseif exist([filename '.mat'],'file')==0;
        found = 1;
        info = loc-1;
    end
end

cd ..%�f�B���N�g�����ɖ߂�
return