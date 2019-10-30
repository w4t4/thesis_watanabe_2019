function nstrings = MakeInfoString(strings, newstring, handle)

stringsz = length(strings);

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

set(handle, 'String', strings);

if flag==0
    for i=position:stringsz
        strings{i} = 'empty-';
    end
end


nstrings = strings;