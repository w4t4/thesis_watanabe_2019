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
crsLoadConstants;
[CheckCard,errorCode] = crsInit;
%vsgfilename = 'C:\Calib\iiyamaPlata\Config.vsg'; % for Erin's machine
%[CheckCard,errorCode] = crsInit(vsgfilename);

if (CheckCard < 0);
    return;
  end;



%Clear the palette to black so no drawing will be seen.
  crsSetCommand(CRS.PALETTECLEAR);
  crsSetDrawPage(CRS.VIDEOPAGE,1,CRS.BACKGROUND);

%Find out the horizontal and vertical resolution of the vsg screen.
    Width = crsGetScreenWidthPixels;
    Height = crsGetScreenHeightPixels;

%Load a TRIVAL with the colour white.
  From = [1 1 1];

%Load a TRIVAL with the colour black.
  Too = [0 0 0];
  Back = (From - Too)./2;
  
%Create a stimulus object.
  crsObjCreate;

%Load the default parameters for the stimulus object.
  crsObjSetDefaults;
  crsSetBackgroundColour(Back);

%Assign the maximum amount of pixel-levels to be used for the object.
  crsObjSetPixelLevels(1, 240);

%Load the object with a sin wave form.
  crsObjTableSinWave(CRS.SWTABLE);

%Load the object with a colour vector (the black and white vsgTRIVALS that were
%loaded earlier.
  crsObjSetColourVector(From,Too, CRS.BIPOLAR);

%set the velocity
  crsObjSetDriftVelocity(0.5);
  
%Select the range of maximum pixel-levels to draw the grating with.
  crsSetPen1(1);
  crsSetPen2(240);

%Draw the grating centered in the middle of the screen.
  crsDrawGrating(0, 0, Width,Height, 90, 0.2);

%Display the object.
  crsPresent;

fprintf('If you want to quit stimulus presentation, click left button.\n');  
fprintf('If you want to continue presentation, click right button and \n');  
fprintf('when you want to quit run this script again and click left button.\n');   
  
flag = 1;
while flag
    [mx,my,buttons] = GetMouse();
    if buttons(1)
        crsSetCommand(CRS.DISABLELUTANIM);
        crsSetCommand(CRS.PALETTECLEAR);
        flag=0;
    elseif buttons(3)
        flag=0;
    end    
end