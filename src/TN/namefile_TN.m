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
    ini = input('Please input subject initials: ','s');	%被験者のイニシャルを受け取る
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
%Get name for condition and error check %これがよく分かりません
cond = input('Please input condition abreviation(leave blank if none exists): ','s');
if isempty(cond)==1
    cond = [];
end
%}

cond = [];

%Create name variable for 'smartsave' %これまでの入力内容からファイル名とフォルダ名を入力
filename = [expname,'_',ini,'_',cond];
foldername = ['\',expname,'_data','\'];%WinとMacの違いか動かなかったので変?X

if isempty(cond)	%?��?名が無いとき?A一文字余るのかそれを調?ﾟしている
    filename = filename(1:end-1);
end


%Set current directory	%現?ﾝのディレクトリを代入
goto = cd;

foldername2=foldername(2:end-1); %WinとMacの違いか動かなかったので?�?ｬ?D多分ファイル名指定方法に違いがあることが原因?D

if exist([goto foldername] ,'dir')==0;	%現?ﾝのディレクトリ以下にデ?[タ入力フォルダがあるかないかを判断し?Aなければフォルダ?�?ｬ
		mkdir (foldername2); %WinとMacの違いか動かなかったので変?X
end

cd([goto foldername]);	%ディレクトリ移動

global DATAFOLDER	%グ�??[バル変?�?骭ｾ
DATAFOLDER = [goto foldername];	%デ?[タフォルダ名を変?狽ﾉ格納

%Check if file already exists, if so append session name.	%ファイル名が?dなった時に?�?曹ｫしないようにファイル名を変?Xするらしい?D
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

cd ..%ディレクトリ元に戻る
return