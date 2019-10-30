% CRTwarmupVSG (ver.1)
% 
% CRT warmup function with VSG.
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Usage:
%     CRTwarmupVSG;
%
% Other explanation:
%     To stop this function, press left button.
%     If you continue the simulus presentation, press right button.
%     After that, run this function again and press left button
%     when you want to stop the stimulus presentation.
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
%     
% Created by Takehiro Nagai on 12/01/2007 (ver.1)
%

function sti_PR650

rand('state',sum(100*clock));
vsgconst;
vsgfilename = '';
if vsg(vsgInit, vsgfilename) < 0
   error('VSG Initialization failed.');
end

Width = vsg(vsgGetScreenWidthPixels);
Height = vsg(vsgGetScreenHeightPixels);

% color index (1-256, -1 using on setpen, and 0 on palette)
BGINDEX = 1;
TESTINDEX = 2;

% prepare page in memory
stipage = 1;
vsg(vsgSetDrawPage,vsgVIDEOPAGE,stipage,1);
vsg(vsgSetPen1, BGINDEX-1);
vsg(vsgDrawRect, 0, 0, Width, Height);
vsg(vsgSetPen1, TESTINDEX-1);
vsg(vsgDrawRect, 0, 0, Width./2, Height./2);

% LUT for just background
bgcolor.a = 0;
bgcolor.b = 0;
bgcolor.c = 0;
palette0 = bgcolor;
palette0 = repmat(palette0,1,256);  % LUT number should be 1-256 (index number should be 0-255)

% present background only
vsg(vsgLUTBUFFERWrite, 1, palette0);
vsg(vsgLUTBUFFERtoPalette,1);
vsg(vsgSetZoneDisplayPage,vsgVIDEOPAGE,stipage);

% main loop
flag = 1;
while flag
    c.a=str2num(input('r value: ','s'));
    c.b=str2num(input('g value: ','s'));
    c.c=str2num(input('b value: ','s'));

    palette1 = palette0;
    palette1(TESTINDEX) = c;
    
    vsg(vsgLUTBUFFERWrite, 2, palette1);
    vsg(vsgLUTBUFFERtoPalette,2);
    
    yn = input('continue(y/n)?','s');
    if yn == 'n'
        flag = 0;
    end
    
end


