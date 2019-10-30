clear all

AssertOpenGL;  % give warning if the psychotoolbox is not based on OpenGL
screenid=max(Screen('Screens'));
[win, winRect] = Screen('OpenWindow', screenid, 0); 
% Find out the size of the lut, install a linear gamma table. This
% happens to be quit important for bits++ too 
[gammatable, dacbits, reallutsize] = Screen('ReadNormalizedGammaTable', win);

linear_gammtable=repmat(linspace(0,1,256)',1,3);   
Screen('LoadNormalizedGammaTable', win, linear_gammtable);% old

Width=winRect(3);
Height=winRect(4);

spot_diam = Height./4;    %radius
blobxdif = (1:Width)-Width./2;
blobydif = (1:Height)-Height./2;    
difsum = sqrt(repmat(blobxdif,Height,1).^2 + repmat(blobydif',1,Width).^2);
testindicies = difsum <= spot_diam;
testindicies_v = reshape(testindicies, Height.*Width, 1);

medium = round(255 .* 0.5.^(1./2.2)); %including nonlinear gamma
backRGB = [medium medium medium];

flag = 1;
while flag
  r = input('R?','s');
  g = input('G?','s');
  b = input('B?','s');
  
  spotRGB = [str2double(r), str2double(g), str2double(b)];
  
  currenttex = repmat(backRGB, [Height*Width 1]);
  currenttex(testindicies_v, 1) = spotRGB(1);
  currenttex(testindicies_v, 2) = spotRGB(2);
  currenttex(testindicies_v, 3) = spotRGB(3);
  currenttex = reshape(currenttex, [Height, Width, 3]);

  StiTextureIndex = Screen('MakeTexture', win, currenttex);
  Screen('DrawTexture', win, StiTextureIndex, [], [0,0,Width,Height]);
  Screen('Flip', win);
  Screen('Close', StiTextureIndex);
  
  cnt = input('continue? (y or n)', 's');
  if cnt=='n'
    flag=0;
  end  
end

