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
    ini = input('Please input subject initials: ','s');	%”íŒ±ŽÒ‚ÌƒCƒjƒVƒƒƒ‹‚ðŽó‚¯Žæ‚é
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
%Get name for condition and error check %‚±‚ê‚ª‚æ‚­•ª‚©‚è‚Ü‚¹‚ñ
cond = input('Please input condition abreviation(leave blank if none exists): ','s');
if isempty(cond)==1
    cond = [];
end
%}

cond = [];

%Create name variable for 'smartsave' %‚±‚ê‚Ü‚Å‚Ì“ü—Í“à—e‚©‚çƒtƒ@ƒCƒ‹–¼‚ÆƒtƒHƒ‹ƒ_–¼‚ð“ü—Í
filename = [expname,'_',ini,'_',cond];
foldername = ['\',expname,'_data','\'];%Win‚ÆMac‚Ìˆá‚¢‚©“®‚©‚È‚©‚Á‚½‚Ì‚Å•Ï?X

if isempty(cond)	%?ðŒ?–¼‚ª–³‚¢‚Æ‚«?Aˆê•¶Žš—]‚é‚Ì‚©‚»‚ê‚ð’²?ß‚µ‚Ä‚¢‚é
    filename = filename(1:end-1);
end


%Set current directory	%Œ»?Ý‚ÌƒfƒBƒŒƒNƒgƒŠ‚ð‘ã“ü
goto = cd;

foldername2=foldername(2:end-1); %Win‚ÆMac‚Ìˆá‚¢‚©“®‚©‚È‚©‚Á‚½‚Ì‚Å?ì?¬?D‘½•ªƒtƒ@ƒCƒ‹–¼Žw’è•û–@‚Éˆá‚¢‚ª‚ ‚é‚±‚Æ‚ªŒ´ˆö?D

if exist([goto foldername] ,'dir')==0;	%Œ»?Ý‚ÌƒfƒBƒŒƒNƒgƒŠˆÈ‰º‚Éƒf?[ƒ^“ü—ÍƒtƒHƒ‹ƒ_‚ª‚ ‚é‚©‚È‚¢‚©‚ð”»’f‚µ?A‚È‚¯‚ê‚ÎƒtƒHƒ‹ƒ_?ì?¬
		mkdir (foldername2); %Win‚ÆMac‚Ìˆá‚¢‚©“®‚©‚È‚©‚Á‚½‚Ì‚Å•Ï?X
end

cd([goto foldername]);	%ƒfƒBƒŒƒNƒgƒŠˆÚ“®

global DATAFOLDER	%ƒOƒ??[ƒoƒ‹•Ï?”?éŒ¾
DATAFOLDER = [goto foldername];	%ƒf?[ƒ^ƒtƒHƒ‹ƒ_–¼‚ð•Ï?”‚ÉŠi”[

%Check if file already exists, if so append session name.	%ƒtƒ@ƒCƒ‹–¼‚ª?d‚È‚Á‚½Žž‚É?ã?‘‚«‚µ‚È‚¢‚æ‚¤‚Éƒtƒ@ƒCƒ‹–¼‚ð•Ï?X‚·‚é‚ç‚µ‚¢?D
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

cd ..%ƒfƒBƒŒƒNƒgƒŠŒ³‚É–ß‚é
return