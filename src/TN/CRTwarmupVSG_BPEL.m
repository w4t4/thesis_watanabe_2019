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

function warmup

rand('state',sum(100*clock));
vsgconst;
vsgfilename = '';
if vsg(vsgInit, vsgfilename) < 0
   error('VSG Initialization failed.');
end


%Clear the palette to black so no drawing will be seen.
  vsg(vsgSetCommand,vsgPALETTECLEAR);
  vsg(vsgSetDrawPage,vsgVIDEOPAGE,1,vsgBACKGROUND);

%Find out the horizontal and vertical resolution of the vsg screen.
    Width = vsg(vsgGetScreenWidthPixels);
    Height = vsg(vsgGetScreenHeightPixels);

%Load a TRIVAL with the colour white.
  From.a = 1;
  From.b = 1;
  From.c = 1;

%Load a TRIVAL with the colour black.
  Too.a = 0;
  Too.b = 0;
  Too.c = 0;
  Back.a = (From.a - Too.a)./2;
  Back.b = (From.b - Too.b)./2;
  Back.c = (From.c - Too.c)./2;
  
%Create a stimulus object.
  vsg(vsgObjCreate);

%Load the default parameters for the stimulus object.
  vsg(vsgObjSetDefaults);
  vsg(vsgSetBackgroundColour,Back);

%Assign the maximum amount of pixel-levels to be used for the object.
  vsg(vsgObjSetPixelLevels,1, 240);

%Load the object with a sin wave form.
  vsg(vsgObjTableSinWave, vsgSWTABLE);

%Load the object with a colour vector (the black and white vsgTRIVALS that were
%loaded earlier.
  vsg(vsgObjSetColourVector, From,Too, vsgBIPOLAR);

%set the velocity
  vsg(vsgObjSetDriftVelocity,0.5);
  
%Select the range of maximum pixel-levels to draw the grating with.
  vsg(vsgSetPen1,1);
  vsg(vsgSetPen2,240);

%Draw the grating centered in the middle of the screen.
  vsg(vsgDrawGrating,0, 0, Width,Height, 90, 0.2);

%Display the object.
  vsg(vsgPresent);

fprintf('If you want to quit stimulus presentation, click left button.\n');  
fprintf('If you want to continue presentation, click right button and \n');  
fprintf('when you want to quit run this script again and click left button.\n');   
  
flag = 1;
while flag
    [mx,my,buttons] = GetMouse();
    if buttons(1)
        vsg(vsgSetCommand, vsgDISABLELUTANIM);
        vsg(vsgSetCommand, vsgPALETTECLEAR);
        flag=0;
    elseif buttons(3)
        flag=0;
    end    
end