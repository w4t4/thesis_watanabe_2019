% adaptationVSG_BPEL (ver.0.9)
%
% Present an adaptation stimuli with a uniform color, 
% usually before experimental sessions begin.
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Usage:
%       adaptationVSG_BPEL(palette, waitsec)
% 
% Input:
%       palette:    LUT palette for background color (desired all LUT to be identical color)
%       waitsec:    presentation period of adaptation stimuli (sec)
%
% Other explanation:
%       This script writes nothing on the memory page, but instead,
%       replace the LUT Buffer (No.1) in the VSG.
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
% 
% Created by Takehiro Nagai on 05/19/2010 (ver.0.9)
%

function adaptationVSG_BPEL(palette, waitsec)
    vsgconst;
    esc = KbName('esc');

    page = 1;       % use page 1
    buffern = 1;    % use LUT buffer 1
    
    % vsg(vsgSetDrawPage,vsgVIDEOPAGE, page,1);
    % vsg(vsgSetPen1, BACKINDEX);
    % vsg(vsgDrawRect, 0, 0, Width, Height);

    vsg(vsgLUTBUFFERWrite, buffern, palette);
    vsg(vsgLUTBUFFERtoPalette, buffern);
    vsg(vsgSetZoneDisplayPage, vsgVIDEOPAGE, page);

    fprintf('Adaptation start...\n');
    fprintf('(Press esc key to stop)\n');
    tic;
    a=1;
    while toc < waitsec   % wait 180 sec
        t=toc;
        [res, sec, keyCode] = KbCheck;
        if t>a*10
            fprintf('%d\n',round(t));
            a=a+1;
        end
        if keyCode(esc); 
            break; 
        end
    end
end

