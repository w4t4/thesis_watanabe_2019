global DATAFOLDER;
global FNAME;
cd (DATAFOLDER);

if ~exist([FNAME,'_tempwkspc'])
    eval(['save ', FNAME]);
else
    eval(['save ', FNAME,'-append']);
end

cd ..