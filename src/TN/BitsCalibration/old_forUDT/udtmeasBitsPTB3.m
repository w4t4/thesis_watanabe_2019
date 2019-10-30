% udtmeasPTB3.m
%
% Measure intensity of a monitor using the UDT S370 photometer.
% Use to measure gamma function or check LUT tables for accuracy.
%
% Measured data is saved to "*.gamb".
% Data for gamma caribration is saved to "*.lut", "*.ilut", "*ilp",
% which will be respectively used by different caribration script,
% "rgb2RGB_LUT", "rgb2RGB_iLUT", and "rgb2RGB_fitting".
% (A temporary binary file,"udtmeas.tmp", stores data while running in case of crash).
%
% 4/10/03 db - correct legend on gamma plots
% 5/3/03 db - save raw data in udtmeas.gam in addition to processed data,
%           - made order of measurements for each requested level random,
%               i.e. measurements are made R,G,B,dark  R,dark,B,G  G,R,dark,B  ...
%           - added initialization of rand state with clock
% 8/19/04 db - changed plotting to single plot showing absolute intensity
%              (intensity before black subtraction)
% 9/22/04 - added option for dac voltage measurement. still needs work.
%
% 10/4/06 - simplify interface, various
% 05/25/07 - setup the script for PTB-3
% 06/29/07 - modify the script for Bits++ w/ PTB-3

disp('udtmeasPTB.m - last revised 29 June 2007')
disp(' ')
disp('If this program exits abnormally, type closeUDT to clear the GPIB interface.')
disp('If you get an error saying ''The specified configuration is not available'',')
disp('You will need to exit and restart Matlab to run this program.')
disp(' ')

clear all

standardPCgamma = 2.2;   % Gamma for calculating approximate intensity when gamma correction is disabled.
rand('state',sum(100*clock)); % initial state of random number generator


try
    
    % --- initialize the UDT first ---
    global udt;
    if (initUDT < 0)
        disp('Error - UDT failed to initialize. You may need to restart matlab.')
        disp('This may be because you exited udtmeas abnormally. Next time, try')
        disp('running "clearudt" after an abnormal exit.')
        closeUDT, return
    end
    
    measgamma = 'y';
    
    
    % --- decide calibration mode ---
    while 1
        disp('What do you want to do?')
        disp('  (g) measure gamma function (disable lookup tables),')
        disp('  (c) check LUTs (enable lookup tables),')
        gammaorcheck = input('? ', 's');
        if gammaorcheck == 'g' || gammaorcheck == 'c'
            break
        end
        disp('      Error -- You must enter ''g'' or ''c''')
    end 

    
    disp(' ')
    disp(' ')
    disp(' Make sure the LUTs are properly configured ...');
    
 

    % --- Bits++ initialization (make the Bits++ receive T-Lock signal) ---
    ResetBits;  
    
    
    % --- monitor initialization ---
    screenid=max(Screen('Screens'));
    AssertOpenGL;   % give warning if the psychotoolbox is not based on OpenGL
    [win, winRect] = Screen('OpenWindow', screenid, 128);

    % Find out the size of the lut, install a linear gamma table. This
    % happens to be quit important for bits++ too 
    [gammatable, dacbits, reallutsize] = Screen('ReadNormalizedGammaTable', win);
    % ----------------Attention!!-------------------
    % ----------------------------------------------
    % linear_gammtable=repmat(linspace(0,1,reallutsize)',1,3);   
    linear_gammtable=repmat(linspace(0,((reallutsize-1)./reallutsize),reallutsize)',1,3);
    % -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
    % Either of two lines above would be effective depending on video cards. 
    % Please comment a unnecessary line out.
    % ----------------------------------------------
    % ----------------------------------------------
    Screen('LoadNormalizedGammaTable', win, linear_gammtable);

    
    % --- Bits++ CLUT initialization ---
    Clut = [1:256; 1:256; 1:256]' * 257;	
    ClutLinear = [1:256; 1:256; 1:256]' * 257;	
    BitsPlusSetClut(win,Clut);	

    
    % --- load data for gamma correction ---
    if gammaorcheck=='c'
        fprintf('\n\n\n\n');
        disp('File name that contains gamma correction parameters');
        fn=input('except the extention: ','s');
        while 1
            LUTmode=input('Bits++ Gamma Correction Mode: (1)normal LUT (2)inverse LUT (3)Fitted Gamma Function: ', 's');
            if LUTmode~='1' && LUTmode~='2' && LUTmode~='3';    disp(' Please input 1~3');
            else   break;    
            end;
        end
        if LUTmode=='3';       para=load([fn '.ilp'],'-ascii');
        elseif LUTmode=='2';   iLUT=load([fn '.ilut'],'-ascii');
        elseif LUTmode=='1';   LUT=load([fn '.lut'],'-ascii');  
        end;
        measgamma = 'n';
    end

    
    % --- variable setting ---
    % spatial and color parameters
    Width=winRect(3);
    Height=winRect(4);
    x0=round(Width./2);
    y0=round(Height./2);
    ColorResolution=reallutsize;
    fullorspot = 's';
    
    % index number (msut be 1~256)
    BACKINDEX = 1;
    TARGETINDEX = 2;
    
    % default color
    if gammaorcheck == 'g'
        if measgamma == 'y'
            medium = round(ColorResolution .* 257 .* 0.5.^(1./standardPCgamma)); %including nonlinear gamma
        elseif gammaorcheck == 'c'
            medium = round(ColorResolution .* 257 .* 0.5); %including linear gamma only
        end 
        backRGB = [medium medium medium];
        spotRGB = [round(medium.*0.8) round(medium.*0.8) round(medium.*0.8)];
    elseif gammaorcheck == 'c'
        if LUTmode == '1';    
            backRGB = rgb2RGB_LUT([0.5 0.5 0.5],LUT);
            spotRGB = rgb2RGB_LUT([0.4 0.4 0.4],LUT);
        elseif LUTmode == '2';  
            backRGB = rgb2RGB_iLUT([0.5 0.5 0.5],iLUT);
            spotRGB = rgb2RGB_iLUT([0.4 0.4 0.4],iLUT);
        elseif LUTmode == '3';
            backRGB = rgb2RGB_fitting([0.5 0.5 0.5],para);
            spotRGB = rgb2RGB_fitting([0.4 0.4 0.4],para);
        end
    end
  
    


    % --- make stimulus texture ---
    testindicies = zeros(Height, Width);
    if fullorspot=='f'
        testindicies = TARGETINDEX;
        disp('Using full field ...')
    elseif fullorspot=='s'
        spot_diam = Height./4;    %radius
        blobxdif = (1:Width)-x0;
        blobydif = (1:Height)-y0;
        difsum = sqrt(repmat(blobxdif,Height,1).^2 + repmat(blobydif',1,Width).^2);
        for i=1:Height		
            for j=1:Width
                if difsum(i,j) > spot_diam
                    testindicies(i,j)=BACKINDEX; 
                else
                    testindicies(i,j)=TARGETINDEX;
                end; 
            end;
        end;
        disp('Using spot ...')
    else
        testindicies = TARGETINDEX;
        disp('You entered something other than "f" or "s". Assuming you want full field ...')
    end
    testindicies = testindicies - 1;    % maintain relationship between pixel value(0~255) and CLUT index(1~256)
    testtexture = Screen( 'MakeTexture', win, testindicies);

          
    
    % --- display stimulus ---
    Clut(BACKINDEX, :) = backRGB;
    Clut(TARGETINDEX, :) = spotRGB;
    ClutEncoded = BitsPlusEncodeClutRow(Clut);
    ClutTextureIndex = Screen('MakeTexture', win, ClutEncoded);
    Screen('DrawTexture', win, testtexture, [], [0,0,Width,Height]);
    Screen('DrawTexture', win, ClutTextureIndex, [], [0,0,524,1]);
    Screen('Flip', win);


    
    % --- ask calibration conditions ---
    WhichGuns = 'a'; % input('Which guns do you want to measure (r/g/b/a)? ', 's');
    shutdn =    input('Shut down the computer when done (y/n)(default n)?: ', 's');
    if isempty(shutdn), shutdn='n'; end
    startval =  0; 
    % input('     Start measuring at level (default 0): ');
    % if isempty(startval), startval=0; end
    endval = 65535;
    % input('     End measuring at level (default 256): ');
    % if isempty(endval), endval=ColorResolution-1; end
    numPoints = input('number of levels to measure (default 256): ');
    if isempty(numPoints), numPoints=256; end
    numSamples =    input('samples per level (minimum 2, default 10): ');
    if isempty(numSamples), numSamples=10; end
    Order = 'r';

    

    % ---- file name to save ----
    if gammaorcheck=='g'
        disp('Please enter a name for the data file (e.g. sony_2004_08_18).')
        ofname = input('File will be saved as <filename>.gam: ','s');
        while fopen([ofname '.gam']) ~= -1
            fclose('all');
            ofname = input(['"' ofname '.gam" already exists. Please enter a different filename: '], 's');
        end
    elseif gammaorcheck=='c'
        disp('Please enter a name for the data file (e.g. sony_2004_08_18).')
        ofname = input('File will be saved as <filename>.chk: ','s');
        while fopen([ofname '.chk']) ~= -1
            fclose('all');
            ofname = input(['"' ofname '.chk" already exists. Please enter a different filename: '], 's');
        end
    else
        closeUDT, return
    end

    
    % --- measuring order setting ---
    switch Order
        case 'h'
            nrange = 'numPoints-1:-1:0';
        case 'l'
            nrange = '0:numPoints-1';
        case 'r'
            nrange = 'randperm(numPoints)-1';
    end
    switch WhichGuns
        case 'r'
            grange = '[1 4]'; NumberOfGuns = 2;
            xgun = 1;
        case 'g'
            grange = '[2 4]'; NumberOfGuns = 2;
            xgun = 2;
        case 'b'
            grange = '[3 4]'; NumberOfGuns = 2;
            xgun = 3;
        case 'a'
            grange = 'randperm(4)'; NumberOfGuns = 4;
            xgun = 1;
    end


    % --- ready? ---
    disp(' ')
    disp('Is the monitor warmed up?')
    disp('Are the lights off?')
    disp(' ')
    
    runtime = 3.*(numPoints-1)*numSamples*NumberOfGuns;
    fprintf('This will take at _minimum_ %3.1f minutes, or %2.2f hours.\n', runtime./60, runtime./3600);
    disp('Press any key to begin measurments...')
    pause
    disp('Beginning measurements ...')
    
    

    
    
    
    % --- make measurements ---
    starttime = clock;
    StepSize = (endval-startval)./(numPoints-1);
    result = zeros(4, numSamples, numPoints-1, 2);

    for sample = 1:numSamples
        for n=eval(nrange)
            for gun = eval(grange)
                fprintf('.');
                
                % rgb determination
                spotRGB(:) = 0;
                x = round(n .* StepSize + startval - 1e-12);
                switch gun
                    case 1			% red
                        spotRGB(1) = x;
                    case 2			% green
                        spotRGB(2) = x;
                    case 3			% blue
                        spotRGB(3) = x;
                    case 4			% dark
                        x=0;
                end   % switch
                
                if gammaorcheck == 'c'
                    normspotRGB=spotRGB./65535;
                    if LUTmode == '1';    
                            spotRGB = rgb2RGB_LUT(normspotRGB,LUT);
                    elseif LUTmode == '2';
                            spotRGB = rgb2RGB_iLUT(normspotRGB,iLUT);
                    elseif LUTmode == '3';
                            spotRGB = rgb2RGB_fitting(normspotRGB,para);
                    end
                end
                
                % stimulus presentation
                Clut(TARGETINDEX, :) = spotRGB;
                ClutEncoded = BitsPlusEncodeClutRow(Clut);
                ClutTextureIndex = Screen('MakeTexture', win, ClutEncoded);
                Screen('DrawTexture', win, testtexture, [], [0,0,Width,Height]);
                Screen('DrawTexture', win, ClutTextureIndex, [], [0,0,524,1]);
                Screen('Flip', win);
                
                % measurement
                result(gun, sample, n+1, :) = [x -ReadUDT];
            end   % for gun
            save udtmeas.tmp result
        end  % for n (level)
        fprintf('%d measurements made, %d/%d repetitions done\n', numPoints, sample, numSamples)
    end % for sample
    stoptime = clock;
    dur=datevec(datenum(stoptime)-datenum(starttime));
    fprintf('Measurements took %d hours and %d minutes\n', dur(4), dur(5));

    
    % ---------------------
    % result indices:(gun, sample number, measurement number, [dac value, intensity])
    % ---------------------
    
    
    % --- deta conversion ---
    % subtract dark measurement
    result_d = result(1:3,:,:,:);
    for gun=1:3, result_d(gun,:,:,2) = result(gun,:,:,2) - result(4,:,:,2); end
        
    % data fro save
    data = [squeeze(result(xgun,1,:,1)) squeeze(mean(result(1:3,:,:,2),2))']; % don't use result_d
    %data = [squeeze(result_d(xgun,1,:,1)) squeeze(mean(result_d(:,:,:,2),2))'];

    % compute correlation coefficient
    ccoef(1,:,:)=corrcoef(data(:,1),data(:,2));
    ccoef(2,:,:)=corrcoef(data(:,1),data(:,3));
    ccoef(3,:,:)=corrcoef(data(:,1),data(:,4));
    ccoefn = ccoef(:,1,2);
    
    
    % --- Done. Close Screen, Bits++ reset, release all ressouces: ---
    Screen('CloseAll');
    % set monitor to background color, close UDT,
    % clear the toolbox dll's from memory
    % gpib('onl', udt, 0);
    closeUDT; 
    clear mex
    ResetBits;

    
    % --- save data to file ---
    if gammaorcheck=='g'
        %save offname data -ascii -tabs
        eval(['save ' ofname '.gamb' ' data -ascii -tabs'])
    elseif gammaorcheck=='c'
        eval(['save ' ofname '.chk' ' data -ascii -tabs'])
        eval(['save ' ofname '.cc' ' ccoefn -ascii -tabs'])
    else
        save
        disp('something went wrong, workspace saved in matlab.mat')
    end
    
        
    % --- interpolation process ---
    if gammaorcheck=='g'
        fitint2voltBits(ofname);
    end
    
     
    %{
    % if gammaorcheck~='v'
    warning off
    % plot the results
    plotcolor = 'rgb';
    %     if gammaorcheck=='v'
    blacksubtracted = 0;
    %     else
    %         blacksubtracted = 1;
    %     end
    % choose which data to plot
    plot_guns = sort(eval(grange));
    figure, hold on
    for gun = plot_guns(1:(size(plot_guns,2)-1))
        %         figure
        if blacksubtracted
            maxi = max(max(max(result_d(:,:,:,2))));
            r = squeeze(result_d(gun,:,:,:));	% result(gun,sample,datapoint, [dac int])
        else
            maxi = max(max(max(result(:,:,:,2))));
            r = squeeze(result(gun,:,:,:));	% result(gun,sample,datapoint, [dac int])
        end
        r(:,:,2)=r(:,:,2)-min(min(r(:,:,2)));
        %         r(:,:,2)=r(:,:,2)./maxi;
        semilogy(r(1,:,1), mean(r(:,:,2),1),[plotcolor(gun) '.'])       % measured intensities
        hold on
        if measgamma == 'y'
            semilogy(r(1,:,1), mean(r(:,:,2),1)+std(r(:,:,2),1)./sqrt(numSamples), 'k')       % measured intensities
            semilogy(r(1,:,1), mean(r(:,:,2),1)-std(r(:,:,2),1)./sqrt(numSamples), 'k')       % measured intensities
        end
        title(['LUMINANCE MEASURED WITHOUT LOOKUP TABLES (saved in ' ofname '.gam)'] )
        legend('mean measured intensity', 'mean + standard error', 'mean - standard error',4)
        if measgamma == 'n'

            mr=squeeze(mean(r,1));
            p=polyfit(mr(:,1),mr(:,2),1)
            linearfit = polyval(p,r(1,:,1));
            err = mean(r(:,:,2),1)-linearfit;
            semilogy(r(1,:,1), linearfit, 'k')
            semilogy(r(1,:,1), abs(err), ['o' plotcolor(gun)])
            title(['LOOKUP-TABLE CORRECTED LUMINANCE saved in ' ofname '.chk)'] )
            legend('mean measured intensity', 'linear fit', 'deviation from linearity',4)
            text(5000, 0.03, ['numSamples = ' num2str(numSamples)])
        end
    end;%if
    %     axis([0 2.^15 2.^-15 1])
    grid on
    xlabel('Requested intensity number (0 -> 32767)')
    if blacksubtracted
        ylabel('Measured intensity - black (scaled so that maximum measurement - black = 1.0)')
    else
        ylabel('Measured intensity (scaled so that maximum measurement = 1.0)')
    end
    warning on
    % end
    delete udtmeas.tmp
    disp(' ')
    eval(['disp(''Done. Data is saved in "' ofname '".'')'])
        %}
       
    
    % --- PC shutdown ---
    if shutdn=='y'
        !shutdown -s -f
        exit
    end
    
    
    % --- finish! ---
    fprintf('\n\n\n\nDone.\n');    

catch
    closeUDT;
    Screen('CloseAll');
     
    % ... rethrow the error.
    psychrethrow(psychlasterror);
end
