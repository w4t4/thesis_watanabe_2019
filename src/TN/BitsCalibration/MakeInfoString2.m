function nstrings = MakeInfoString2(window, strings, newstring)

stringsz = length(strings);

% conversion of text information
position=0;
flag=1;
for i=1:stringsz
    if strcmp(strings{i},'empty-')
        strings{i}=newstring;
        position = i+1;
        flag=0;
        break;
    end
end

if flag==1
    for i=1:stringsz-1
        strings{i} = strings{i+1};
    end
    strings{stringsz} = newstring;
else
    for i=position:stringsz
        strings{i} = ' ';
    end
end



% presentation
Screen(window,'FillRect',255);
for i=1:stringsz
   Screen('DrawText', window, strings{i}, 16, i.*16);
end
Screen('Flip',window, [], 1);

% conversion of text information 2
if flag==0
    for i=position:stringsz
        strings{i} = 'empty-';
    end
end

% return
nstrings = strings;
