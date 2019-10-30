function [Result Lum] = MinimumMotion(sf,L0,ppi)


% [Result Lum] = MinimumMotion(sf,L0,ppi)
% 
%
% sf : spatial frequency
% L0 : standard luminance (G phosphor)
% ppi : position index
%
% Result: matched R gun value
% Lum: matched R luminance
%
% quits when holding ESCAPE
%
% adjustment: rightArrow and leftArrow keys
% fix: return key
%
% reference
% Anstis, S. M.& Cavanagh, P. (1983). A minimum motion technique for judging equiluminance. In Mollon, J. D. & Sharpe, L. T. (Eds), Colour vision: physiology and psychophysics (pp. 155-166). London: Academic Press
%
% start writing 2007 08 13 by NO


% clear

%-------------------------------------
%---------- param setup --------------
%-------------------------------------

if nargin > 4
    error('Usage: [Result Lum] = MinimumMotion(sf,L0,ppi)');
end

switch nargin
    case 0
        sf = 2;
        L0 = 13;
        ppi = 5;

    case 1
        L0 = 13;
        ppi = 5;
    case 2
        ppi = 5;
end

%rand('state',sum(100*clock));

%size screen
params.sizescreen=[36 27]; %width height (cm) <----EIZO FlexScan
params.viewdist=57; % viewer distance (cm)
params.screenpix=[1280 1024]; %pixel resolution <----EIZO FlexScan

params.degperpix=180/pi*mean(atan((params.sizescreen./params.screenpix)./params.viewdist));
params.pixperdeg=1./params.degperpix;

Ycontrast = 6.25; % Yellow grating contrast in % (S. Anstis and P. Cavanagh, 1983)

%gamma param
Rgamma = [0.000046 	1.890100 	56.754000 	-0.004383];  %measured by BM-8
Ggamma = [0.000035307 	1.9138	42.207	-0.0017386];     %measured by BM-8
Bgamma = [0.000035489 	1.9003	35.85	-0.0064823];     %measured by BM-8

%XR255 = 31.510 ; %measured by BM-8
%YR255 = 17.518 ; %measured by BM-8
%ZR255 = 1.217 ;  %measured by BM-8
%XG255 = 21.109  ;%measured by BM-8
%YG255 = 46.498  ;%measured by BM-8
%ZG255 = 8.491 ;  %measured by BM-8
%XB255 = 12.384 ; %measured by BM-8
%YB255 = 5.145  ; %measured by BM-8
%ZB255 = 64.762 ; %measured by BM-8
% 
%X0 = 0.01474;  %measured by BM-8
%Y0 = 0.01283;  %measured by BM-8
%Z0 = 0.01361;  %measured by BM-8

maxRGB = [16.19	48.6	4.79]; %measured by BM-8, luminance at 255 gun
minRGB = [0.02	0.01	0.02]; %measured by BM-8, luminance at   0 gun

Lr = (L0-minRGB(1))/(maxRGB(1)-minRGB(1));  % normalize
Lg = (L0-minRGB(2))/(maxRGB(2)-minRGB(2));  % normalize
Lb = (L0-minRGB(3))/(maxRGB(3)-minRGB(3));  % normalize

Rgun =round(((Lr + Rgamma(4))/ Rgamma(1) )^(1/Rgamma(2)) + Rgamma(3)); % initial R
Ggun =round(((Lg + Ggamma(4))/ Ggamma(1) )^(1/Ggamma(2)) + Ggamma(3)); % fixed G
Bgun =round(((Lb + Bgamma(4))/ Bgamma(1) )^(1/Bgamma(2)) + Bgamma(3)); % not-yet

%Up = KbName('upArrow');
%Down = KbName('downArrow');
    % for mac
%Right = KbName('rightArrow');
%Left = KbName('leftArrow');
%yesKey = KbName('return');
%esc = KbName('escape');
    % for win
Right = KbName('right');
Left = KbName('left');
yesKey = KbName('return');
esc = KbName('esc');

%-----------------------------------
%---- background color setup -------
%-----------------------------------

%RGBBackground = XYZ2GunValue(L0,L0,L0);
%RGBBackground16bit = XYZ2GunValue16bit(L0,L0,L0); %<- gunvalue, needs conversion to clut value
%Framecolor = XYZ2GunValue16bit(2*L0,2*L0,2*L0);

%-----------------------------------
%-----------------------------------
%-----------------------------------


sz=1;   
imsize=[4 1];   %stimulus image size in degrees
PeriDeg=10;     %peripheral stimulus visual angle (eccentricity) in degrees
%dt=0.2;         %stimulus display time

%-which screen
screenNumber=max(Screen('screens'));
 
%----------------------------------------
%            --reference--
%size=round(viewangle.*params.pixperdeg);
%----------------------------------------

FixationPointSize = 0.1;    % in degrees
FrameSize = 1;
FrameDistance = 0.2;

% ----- cortical magnification factor -----
%Nasal
Mnp = (1 + 0.33 * PeriDeg + 0.00007 * PeriDeg^3)^(-1); %peripheral
%Mnf = (1 + 0.33 * ((sz + FrameDistance)/2) + 0.00007 * ((sz + FrameDistance)/2)^3)^(-1); %foveal

%Superior
Msp = (1 + 0.42 * PeriDeg + 0.00012 * PeriDeg^3)^(-1); %peripheral

%Temporal
Mtp = (1 + 0.29 * PeriDeg + 0.000012 * PeriDeg^3)^(-1); %peripheral
%Mtf = (1 + 0.29 * ((sz + FrameDistance)/2) + 0.000012 * ((sz + FrameDistance)/2)^3)^(-1);

%Inferior
Mip = (1 + 0.42 * PeriDeg + 0.000055 * PeriDeg^3)^(-1); %peripheral

% Horizontal
Mhp = mean([Mnp Mtp]);
%Mhf = mean([Mnf Mtf]);

% Vertical
Mvp = mean([Msp Mip]);

% position 4 or 6 (horizontal)
M4or6 = 1/Mhp;
%position 8 or 2 (vertical)
M8or2 = 1/Mvp;

% position 1, 3, 7, or 9 (diagonal)

Mdiagonal = 1/((Mhp + Mvp)/2);

CorticalMagnificationFactor2 =zeros(1,1,9); %memory securement
CorticalMagnificationFactor2(:,:,1) = Mdiagonal;
CorticalMagnificationFactor2(:,:,2) = M8or2;
CorticalMagnificationFactor2(:,:,3) = Mdiagonal;
CorticalMagnificationFactor2(:,:,4) = M4or6;
CorticalMagnificationFactor2(:,:,5) = 1;
CorticalMagnificationFactor2(:,:,6) = M4or6;
CorticalMagnificationFactor2(:,:,7) = Mdiagonal;
CorticalMagnificationFactor2(:,:,8) = M8or2;
CorticalMagnificationFactor2(:,:,9) = Mdiagonal;

for i=1:9
    imsize2(:,:,i) = imsize.* CorticalMagnificationFactor2(1,1,i);
end


%PeriFrameSize2 = FrameSize * CorticalMagnificationFactor2;


%---------------------------------------
%---------------------------------------
%---- prefixed stimulus position -------
%---------------------------------------
%---------------------------------------

%----stimulus position (8 direction & foveal)
PeriferalPosition(9,:) = params.screenpix./2+[PeriDeg*params.pixperdeg*sqrt(2)/2 -PeriDeg*params.pixperdeg*sqrt(2)/2]; 
PeriferalPosition(6,:) = params.screenpix./2+[PeriDeg*params.pixperdeg 0]; 
PeriferalPosition(3,:) = params.screenpix./2+[PeriDeg*params.pixperdeg*sqrt(2)/2 PeriDeg*params.pixperdeg*sqrt(2)/2];
PeriferalPosition(8,:) = params.screenpix./2+[0 -PeriDeg*params.pixperdeg];
PeriferalPosition(5,:) = params.screenpix./2;
PeriferalPosition(2,:) = params.screenpix./2+[0 PeriDeg*params.pixperdeg]; 
PeriferalPosition(7,:) = params.screenpix./2+[-PeriDeg*params.pixperdeg*sqrt(2)/2 -PeriDeg*params.pixperdeg*sqrt(2)/2];
PeriferalPosition(4,:) = params.screenpix./2+[-PeriDeg*params.pixperdeg 0]; 
PeriferalPosition(1,:) = params.screenpix./2+[-PeriDeg*params.pixperdeg*sqrt(2)/2 PeriDeg*params.pixperdeg*sqrt(2)/2];

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%----------------------- display and adjustment ---------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

try

    %-- Open window
    %[window,screenRect] = Screen('OpenWindow',screenNumber,128,[],32,2);
    [window,screenRect] = Screen('OpenWindow',screenNumber,0,[],32,2);
    
    Screen('LoadNormalizedGammaTable',window,linspace(0,(255/256),256)'*ones(1,3));
     
    
    %switcher = [1 0 0; 0 1 0; 0 0 1];
        
    linear_lut =  repmat(round(linspace(0, 2^16 -1, 256))', 1, 3);
%    Clut = LumRGYB2RGBtable(BackGLumRGYB + (-Cmax/100)*BackGLumRGYB.* switcher(color,:), BackGLumRGYB + (Cmax/100)*BackGLumRGYB.* switcher(color,:));
    
    %linear_lut(1, :) = Framecolor;
    
    BitsPlusSetClut(window,linear_lut);


    %%---- Fixation Point
    Screen('FillOval',window,[255 255 255],[round(params.screenpix./2-FixationPointSize.*params.pixperdeg/2) round(params.screenpix./2+FixationPointSize.*params.pixperdeg/2)]);
    %KbWait;
    Screen('Flip',window); 
            
    
    %---------------------------------------
    %---------------------------------------
    %---------------- LOOP -----------------
    %---------------------------------------
    %---------------------------------------

    brk = 0;
    Return = 0;
            
            %----------------------------------------
            %            --reference--
            %size=round(viewangle.*params.pixperdeg);
            %----------------------------------------

            
            KbWait;          % <---- start trial
            Snd('Play',sin(0:300));
            %Rgun = 200; % initial R
            
    while brk == 0 && Return == 0
            %%%%%%%%%%%%%%%%%
            %%%% phase 1 %%%% R and G grating
            %%%%%%%%%%%%%%%%%
            Screen('FillRect',window, [0 Ggun 0], [round(PeriferalPosition(ppi,:)-imsize2(:,:,ppi).*params.pixperdeg/2) round(PeriferalPosition(ppi,:)+imsize2(:,:,ppi).*params.pixperdeg/2)]);
            for i= 1:4*sf
                Screen('FillRect',window, [Rgun 0 0], [round(PeriferalPosition(ppi,:)+(-imsize2(:,:,ppi)./2+([(i-1)/sf 0]).*CorticalMagnificationFactor2(:,:,ppi)).*params.pixperdeg) round(PeriferalPosition(ppi,:)+(-imsize2(:,:,ppi)./2+([(i-1)/sf+1/(2*sf) imsize(2)]).*CorticalMagnificationFactor2(:,:,ppi)).*params.pixperdeg)]);
            end
            %%---- Fixation Point
            Screen('FillOval',window,[255 255 255],[round(params.screenpix./2-FixationPointSize.*params.pixperdeg/2) round(params.screenpix./2+FixationPointSize.*params.pixperdeg/2)]);
            Screen('Flip',window);
            %WaitSecs(dt);
            
            %%%%%%%%%%%%%%%%%
            %%%% phase 2 %%%% Yellow grating
            %%%%%%%%%%%%%%%%%
            Screen('FillRect',window, [(Rgun/2)*(1+Ycontrast/100) (Ggun/2)*(1+Ycontrast/100) 0], [round(PeriferalPosition(ppi,:)-imsize2(:,:,ppi).*params.pixperdeg/2) round(PeriferalPosition(ppi,:)+imsize2(:,:,ppi).*params.pixperdeg/2)]);
            for i=1:4*sf
                Screen('FillRect',window, [(Rgun/2)*(1 - Ycontrast/100) (Ggun/2)*(1 - Ycontrast/100) 0], [round(PeriferalPosition(ppi,:)+(-imsize2(:,:,ppi)./2+([(i-1)/sf+1/(4*sf) 0]).*CorticalMagnificationFactor2(:,:,ppi)).*params.pixperdeg) round(PeriferalPosition(ppi,:)+(-imsize2(:,:,ppi)./2+([(i-1)/sf+1/(4*sf)+1/(2*sf) imsize(2)]).*CorticalMagnificationFactor2(:,:,ppi)).*params.pixperdeg)]);
            end
            %%---- Fixation Point
            Screen('FillOval',window,[255 255 255],[round(params.screenpix./2-FixationPointSize.*params.pixperdeg/2) round(params.screenpix./2+FixationPointSize.*params.pixperdeg/2)]);
            Screen('Flip',window);
            %WaitSecs(dt);
            
            %%%%%%%%%%%%%%%%%
            %%%% phase 3 %%%% R and G grating
            %%%%%%%%%%%%%%%%%
            Screen('FillRect',window, [0 Ggun 0], [round(PeriferalPosition(ppi,:)-imsize2(:,:,ppi).*params.pixperdeg/2) round(PeriferalPosition(ppi,:)+imsize2(:,:,ppi).*params.pixperdeg/2)]);
            for i= 1:4*sf
                Screen('FillRect',window, [Rgun 0 0], [round(PeriferalPosition(ppi,:)+(-imsize2(:,:,ppi)./2+([1/(2*sf)+(i-1)/sf 0]).*CorticalMagnificationFactor2(:,:,ppi)).*params.pixperdeg) round(PeriferalPosition(ppi,:)+(-imsize2(:,:,ppi)./2+([1/(2*sf)+(i-1)/sf+1/(2*sf) imsize(2)]).*CorticalMagnificationFactor2(:,:,ppi)).*params.pixperdeg)]);
            end
            %%---- Fixation Point
            Screen('FillOval',window,[255 255 255],[round(params.screenpix./2-FixationPointSize.*params.pixperdeg/2) round(params.screenpix./2+FixationPointSize.*params.pixperdeg/2)]);
            Screen('Flip',window);
            %WaitSecs(dt);
            
            %%%%%%%%%%%%%%%%%
            %%%% phase 4 %%%% Yellow grating
            %%%%%%%%%%%%%%%%%
            Screen('FillRect',window, [(Rgun/2)*(1 - Ycontrast/100) (Ggun/2)*(1 - Ycontrast/100) 0], [round(PeriferalPosition(ppi,:)-imsize2(:,:,ppi).*params.pixperdeg/2) round(PeriferalPosition(ppi,:)+imsize2(:,:,ppi).*params.pixperdeg/2)]);
            for i=1:4*sf
                Screen('FillRect',window, [(Rgun/2)*(1+Ycontrast/100) (Ggun/2)*(1+Ycontrast/100) 0], [round(PeriferalPosition(ppi,:)+(-imsize2(:,:,ppi)./2+([(i-1)/sf+1/(4*sf) 0]).*CorticalMagnificationFactor2(:,:,ppi)).*params.pixperdeg) round(PeriferalPosition(ppi,:)+(-imsize2(:,:,ppi)./2+([(i-1)/sf+1/(4*sf)+1/(2*sf) imsize(2)]).*CorticalMagnificationFactor2(:,:,ppi)).*params.pixperdeg)]);
            end
            %%---- Fixation Point
            Screen('FillOval',window,[255 255 255],[round(params.screenpix./2-FixationPointSize.*params.pixperdeg/2) round(params.screenpix./2+FixationPointSize.*params.pixperdeg/2)]);
            Screen('Flip',window);
            %WaitSecs(dt);
            
            
      
    
            % ----- response
            keyCode=zeros(1,256);
            [res, sec, keyCode] = KbCheck;
            if max(keyCode([1:39 42:78 81:256])) == 1
                GiveFeedback(0);
            end
            
            if keyCode(Right) == 1
                Rgun = Rgun - 1;
                Rgun=max([0 Rgun]);
            elseif  keyCode(Left) == 1
                Rgun = Rgun + 1;
                Rgun=min([255 Rgun]);
            end
                
            brk = keyCode(esc);
            Return = keyCode(yesKey(1));
       
    end
    
    Result = Rgun;
    Lum_r = ((Rgun - Rgamma(3)) ^(Rgamma(2)))*Rgamma(1) - Rgamma(4)  ;
    Lum = Lum_r * (maxRGB(1) - minRGB(1)) - minRGB(1);
    
    
    %linear_lut =  repmat(round(linspace(0, 2^16 -1, 256))', 1, 3);
    %BitsPlusSetClut(window,linear_lut);
    
    Screen('CloseAll');
    %ShowCursor;
    %clear mex;
    %figure;
    %plot(contrast')

catch
    %linear_lut =  repmat(round(linspace(0, 2^16 -1, 256))', 1, 3);
    %BitsPlusSetClut(window,linear_lut);
    Screen('CloseAll')
    %ShowCursor;
    rethrow(lasterror)
    psychrethrow(psychlasterror);
end


