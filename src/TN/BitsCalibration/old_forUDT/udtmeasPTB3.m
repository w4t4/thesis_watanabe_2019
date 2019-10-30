% udtmeasPTB3.m
%
% Measures intensity of a monitor using the UDT S370 photometer.
% Use to measure gamma function or check LUT tables for accuracy.
%
% Data is saved to "udtmeas.gam" or "udtmeas.lut" depending on whether gamma
% function or lut-corrected luminance is measured. (A temporary binary file,
% "udtmeas.tmp", stores data while running in case of crash).
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
disp('udtmeasPTB.m - last revised 19 April 2007 - type "help VISUCSD" for usage instructions.')
disp(' ')
disp('If this program exits abnormally, type closeUDT to clear the GPIB interface.')
disp('If you get an error saying ''The specified configuration is not available'',')
disp('You will need to exit and restart Matlab to run this program.')
disp(' ')

clear all

standardPCgamma = 2.2;   % Gamma for calculating approximate intensity when gamma correction is disabled.
rand('state',sum(100*clock)); % initial state of random number generator


try
    %initialize the UDT first
    
    global udt;
    if (initUDT < 0)
        disp('Error - UDT failed to initialize. You may need to restart matlab.')
        disp('This may be because you exited udtmeas abnormally. Next time, try')
        disp('running "clearudt" after an abnormal exit.')
        closeUDT, return
    end
    
    measgamma = 'y';
    
    % in case you want to check the currently configured LUT's
    while 1
        disp('What do you want to do?')
        disp('  (g) measure gamma function (disable lookup tables),')
        disp('  (c) check LUTs (enable lookup tables),')
        disp('  (v) measure DAC voltages.')
        gammaorcheck = input('? ', 's');
        if gammaorcheck == 'g' | gammaorcheck == 'c' | gammaorcheck == 'v'
            break
        end
        disp('      Error -- You must enter ''g'', ''c'', or ''v''')
    end

    % Find screen with maximal index:
 screenid=max(Screen('Screens'));

    disp(' ')
    if  gammaorcheck == 'v'
        disp('========= You will be measuring voltages output by the VSG board ==========')
        disp(' ')
        disp(' 1. Make sure the LUTs are properly configured ...');
        disp(' ')
        disp('      the vsg monitor configuration file (*.vsg) file must point to dacvoltage.lut')
        disp('      as the red, blue, and green LUT. For example:')
        disp(' ')
        disp('      ...')
        disp('      red lut file          =C:\MATLAB701\toolbox\VSGcal\dacvoltage.lut  ')
        disp('      blue lut file         =C:\MATLAB701\toolbox\VSGcal\dacvoltage.lut  ')
        disp('      green lut file        =C:\MATLAB701\toolbox\VSGcal\dacvoltage.lut  ')
        disp('      ...')
        disp(' ')
        disp('      (if "dacvoltage.lut" is missing, it can be generated using mkdaclut.m)')
        disp(' ')
        disp(' 2. You will need to run udtmeas once for each VSG color output. Connect the')
        disp('    voltmeter (UDTS370+yellow voltage probe) to the red, green, and blue VSG')
        disp('    output in turn, running udtmeas each time. ')
        disp(' ')
    else
        disp(' ')
        disp(' Make sure the LUTs are properly configured ...');
    end

    % Abort script if it isn't executed on Psychtoolbox-3:
    AssertOpenGL;

    % Open fullscreen onscreen window on that screen. Background color is
    % gray, double buffering is enabled. Return a 'win'dowhandle and a
    % rectangle 'winRect' which defines the size of the window.
    [win, winRect] = Screen('OpenWindow', screenid, 128);

    % find out the size of the lut, install a linear gamma table
    [gammatable, dacbits, reallutsize] = Screen('ReadNormalizedGammaTable', win);
    linear_gammtable=repmat(linspace(0,1,reallutsize)',1,3);
    disp('a')
    Screen('LoadNormalizedGammaTable', win, linear_gammtable);
    disp('b')


    if( gammaorcheck=='c'  | gammaorcheck == 'v')
        %     if vsg(vsgSetVideoMode, vsgGAMMACORRECT) < 0
        %         beep; disp('SetVideoMode Failed! Exiting ...');
        %         closeudt, return;
        %     end
        %     measgamma = 'n';
        fn=input('File name that contains the ''InvGammaTable'' matrix for this display: ','s');
%         ['load -mat ' fn ' gammatable']
%         eval(['load -mat ' fn ' gammatable'])
        load(fn,'-mat')
        measgamma = 'n';
        Screen('LoadNormalizedGammaTable', win, InvGammaTable); %if name of the lut variable is different from InvGammaTable - change here!
       
end

    Width=winRect(3);
    Height=winRect(4);
    x0=round(Width./2);
    y0=round(Height./2);
    ColorResolution=reallutsize;

    % set up colors
    if measgamma == 'y'
        medium=round(ColorResolution .* 0.5.^(1./standardPCgamma)); %including nonlinear gamma
    else
        medium = round(ColorResolution .* 0.5); %including linear gamma only
    end
    %     disp(' ')
    %     surroundRGB=input('Surround [R G B] vector (default [.5 .5 .5]): ');
    %     if isempty(surroundRGB), surroundRGB=[0.5 0.5 0.5]; end
    %     disp(' ')
    surroundRGB=[0.5 0.5 0.5].^(1./standardPCgamma);
    background.a = round(ColorResolution.*surroundRGB(1));
    background.b = round(ColorResolution.*surroundRGB(2));
    background.c = round(ColorResolution.*surroundRGB(3));
    spot0.a = round(0.9.*medium);
    spot0.b = round(0.9.*medium);
    spot0.c = round(0.9.*medium);

    Screen('FillRect', win, [background.a background.b background.c], winRect);

    if gammaorcheck == 'v'
        fullorspot = 'f';
    else
        fullorspot = 's';
        % else
        %         fullorspot = input('Full field or spot (f/s)? ','s');
    end
    if fullorspot=='f'
        Screen('FillRect', win, [spot0.a spot0.b spot0.c], winRect);
        disp('Using full field ...')
    elseif fullorspot=='s'
        spot_diam=300;
        Screen('FillOval', win, [spot0.a spot0.b spot0.c], [x0-spot_diam./2 y0-spot_diam./2 x0+spot_diam./2 y0+spot_diam./2] );
        disp('Using spot ...')
    else
        Screen('FillRect', win, [spot0.a spot0.b spot0.c], winRect);
        disp('You entered something other than "f" or "s". Assuming you want full field ...')
    end
    % display it
    Screen('Flip', win);

    if gammaorcheck == 'v'
        WhichGuns = input('Which DAC output do you want to measure (r/g/b)? ', 's');
        %     allORminmax = input('Measure (a)ll DAC voltages, or (m)inimum and maximum only? ', 's');
        allORminmax = 'm';
        if allORminmax == 'a'
            startval = 0;
            endval = 511;
            numPoints = 512;
        elseif allORminmax == 'm'
            startval = 0;
            endval = 511;
            numPoints = 3;
        end
    else
        WhichGuns = 'a'; % input('Which guns do you want to measure (r/g/b/a)? ', 's');
%         disp('Press enter for defaults ...')
        shutdn =    input('Shut down the computer when done (y/n)(default n)?: ', 's');
        if isempty(shutdn), shutdn='n'; end
        startval =  0; %input('     Start measuring at level (default 0): ');
        if isempty(startval), startval=0; end
        endval = 255; %   input(['                 to level (default ' num2str(ColorResolution-1) '): ']);
        if isempty(endval), endval=ColorResolution-1; end
        numPoints = input('number of levels to measure (default 256): ');
        if isempty(numPoints), numPoints=256; end
    end
    numSamples =    input('samples per level (minimum 2, default 10): ');
    if isempty(numSamples), numSamples=10; end
    % if WhichGuns == 'a'
    %     disp('Measurement of each R, G, and B triplet will be in random color order.')
    % end
    % Order = input('Order of intensity or voltage values? (r)andom, (h)igh start, (l)ow start: ', 's');
    Order = 'r';

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
    elseif gammaorcheck=='v'
        disp('Please enter a name for the data file (e.g. VSG519red).')
        ofname = input('File will be saved as <filename>.vlt: ','s');
        while fopen([ofname '.vlt']) ~= -1
            fclose('all');
            ofname = input(['"' ofname '.vlt" already exists. Please enter a different filename: '], 's');
        end
    else
        closeUDT, return
    end


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

    if gammaorcheck=='v'
        disp(' ')
        disp('Make sure the voltage probe is connected to the correct VSG output')
        disp(' ')
    else
        disp(' ')
        disp('Is the monitor warmed up?')
        disp('Are the lights off?')
        disp(' ')
    end

    runtime = 3.*(numPoints-1)*numSamples*NumberOfGuns;
    fprintf('This will take at _minimum_ %3.1f minutes, or %2.2f hours.\n', runtime./60, runtime./3600);
    disp('Press any key to begin measurments...')
    pause
    disp('Beginning measurements ...')
    starttime = clock

    % make the measurements
    StepSize = (endval-startval)./(numPoints-1)
    result = zeros(4, numSamples, numPoints-1, 2);

    for sample = 1:numSamples
        for n=eval(nrange)
            for gun = eval(grange)
                fprintf('.');
                spot.a = 0;
                spot.b = 0;
                spot.c = 0;
                x = round(n .* StepSize + startval - 1e-12);  % small offset so that 511/2 = 255.5 rounds down to 255 for voltage measurement
                switch gun
                    case 1			% red
                        spot.a = x;
                    case 2			% green
                        spot.b = x;
                    case 3			% blue
                        spot.c = x;
                    case 4			% dark
                        x=0;
                        spot.a = 0;
                        spot.b = 0;
                        spot.c = 0;
                end   % switch
                %             vsg(vsgPaletteSet, 2, 2, spot);
                Screen('FillOval', win, [spot.a spot.b spot.c], [x0-spot_diam./2 y0-spot_diam./2 x0+spot_diam./2 y0+spot_diam./2] );
                Screen('Flip', win);
                result(gun, sample, n+1, :) = [x -ReadUDT]; % !!!
            end   % for gun
            save udtmeas.tmp result
        end  % for n
        fprintf('%d measurements made, %d/%d repetitions done\n', numPoints, sample, numSamples)
    end % for sample
    stoptime = clock
    dur=datevec(datenum(stoptime)-datenum(starttime));
    fprintf('Measurements took %d hours and %d minutes\n', dur(4), dur(5))

    % result indices:(gun, sample number, measurement number, [dac value, intensity])
    result_d = result(1:3,:,:,:);
    if gammaorcheck~='v'
        disp('Subtracting dark measurements ...');
        for gun=1:3, result_d(gun,:,:,2) = result(gun,:,:,2) - result(4,:,:,2); end
    end

    % save data
    data = [squeeze(result_d(xgun,1,:,1)) squeeze(mean(result_d(:,:,:,2),2))'];
    % data = [squeeze(result_d(xgun,1,:,1)) squeeze(median(result_d(:,:,:,2),2))'];

    % Done. Close Screen, release all ressouces:
    Screen('CloseAll');
    % set monitor to background color, close UDT,
    % clear the toolbox dll's from memory
    % gpib('onl', udt, 0);
    closeUDT;
    clear mex

    if gammaorcheck=='g'
        eval(['save ' ofname '.gam'])
    elseif gammaorcheck=='c'
        eval(['save ' ofname '.chk'])
    elseif gammaorcheck=='v'
        eval(['save ' ofname '.vlt'])
    else
        save
        disp('something went wrong, workspace saved in matlab.mat')
    end

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
    if gammaorcheck=='v'
        title(['VOLTAGE MEASURED USING SPECIFIED LUTs (saved in ' ofname '.vlt)'] )
        legend('mean measured voltage', 'mean + standard error', 'mean - standard error',4)
        ylabel('Measured voltage (scaled so that maximum measurement = 1.0)')
    end
    warning on
    % end

    delete udtmeas.tmp

    disp(' ')
    eval(['disp(''Done. Data is saved in "' ofname '".'')'])
    disp('If you want to generate LUTs, you will need DAC voltage files (red.dac, green.dac, blue.dac) for your VSG card.')
    disp('Use the files that came with the card, or run udtmeas again to measure the DAC voltages.')
    disp(' ')
    disp('Run "fitInt2Volt.m" next once you have the DAC voltage files available.')
    disp(' ')
    disp('Run "mkDACfile.m" to generate DAC voltage files from voltage measurements.')
    disp(' ')

    if shutdn=='y'
        !shutdown -s -f
        exit
    end

catch
    closeUDT
    % Our usual error handler: Close screen and then...
    Screen('CloseAll');
     
    % ... rethrow the error.
    psychrethrow(psychlasterror);
end