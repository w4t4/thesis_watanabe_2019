% CRTwarmupPTB_ubuntu (ver.2)
% 
% CRT warmup function for Psychtoolbox on Ubuntu.
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Usage:
%     CRTwarmupPTB_ubuntu;
%
% Other explanation:
%     To stop this function, press an any key.
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
%     
% Created by Takehiro Nagai on 05/01/2015 (ver.1)
% Recreated by Takehiro Nagai on 05/19/2015 (ver.2)

function CRTwarmupPTB_ubuntu

clear all

KbName('UnifyKeyNames');
esc = KbName('Escape');

sf = 200;

try
	AssertOpenGL;
	screens=Screen('Screens');
	screenNumber=max(screens);
	
	[win winRect]=Screen('OpenWindow',screenNumber, 0,[],32,2);
    Screen('FillRect',win, round(255./2));
	Screen('Flip', win);
	
	offid = Screen('OpenOffscreenWindow', win, 1, [0,winRect(2),sf,winRect(4)]);
	for l=1:sf
	    color = round((sin(l./sf.*2*pi).+1)./2.*255);
	    color = [color,color,color];
	    Screen('FillRect', offid, color, [l-1, winRect(2), l, winRect(4)]);
	end
	img = Screen('GetImage', offid);
	
	fprintf('Press esc key to quit.\n');
	fflush(1);
	flag = 0
	pos = -sf;
	copynum = round(winRect(3)./sf)+2;
	while ~flag
	    for rep = 1:copynum
	        Screen('DrawTexture', win, offid, [], [pos+(rep-1).*sf, winRect(2), pos+sf+(rep-1).*sf, winRect(4)]);
	    end
	    Screen('Flip', win);
	    pos = pos+1;
	    if pos>0
	        pos=-sf;
	    end
	    
	    [ keyIsDown, seconds, keyCode ] = KbCheck;
        if keyIsDown && keyCode(esc)
            flag = 1;
        end 
	    
	end
	
	
	Screen('CloseAll');

catch

    Screen('CloseAll');
    Priority(0);

end




