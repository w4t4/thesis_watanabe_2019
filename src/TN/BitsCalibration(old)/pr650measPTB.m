% pr650meas.m - measure display spectra using the PR650
%
% notes:
% - before reading from the serial port, either wait for a second,
%   or check to see if the expected number of bytes is available.
% - default input buffer size is very small (512 bytes)
% - once the pr650 is in remote mode, the serial port can be closed and
%   reopened without restarting the pr650, so pr650meas can be run multiple
%   times as long as it exits normally.
clear all
disp('============= pr650meas.m ===============')
disp('assuming you will be using serial port COM1 ...')
disp(' ')
try
    avgcnt = 3;   % number of measurements to average
    port = 'COM1'; % serial port
    M5BYTES = 1734; % number of bytes to wait for after 'm5' command
    INBUFSZ = 2000; % size of input buffer

    % initialize a serial port object
    s = serial(port);
    s.InputBufferSize = INBUFSZ;
    fopen(s)

    disp('Connect the PR650. The procedure for initializing the PR650 is:')
    disp(' ')
    disp('  1. Push red button to turn PR650 on,')
    disp('  2. Wait 1-2 seconds for the "CMD" prompt on the PR650 display,')
    disp('  3. Press any key on the computer keyboard to initialize serial')
    disp('     communication.')
    disp(' ')
    disp('If you wait too long, the PR650 will go into normal (non remote) mode.')
    disp(' ')
    disp('When you are ready, follow the instructions above to continue ...')
    pause

    fprintf(s,'r'), pause(1)    % enter pr650 remote mode
    flushinput(s)   % response to the 'r' command is not specified
    disp('PR650 should be in remote mode now.')
    disp(' ')
    % disp('Please confirm. If "remote mode" is not displayed on the PR650,')
    % if strcmp(input('type "exit" now and run pr650meas again, else press enter: ', 's'), 'exit')
    %     fclose(s); delete(s); clear s; return
    % end

    % initialize measurement parameters
    sync = 0;%input('Synchronize PR650 to display refresh rate (0/1)? ');
    useND = 0;%input('Are you using the accessory neutral density filter (0/1)? ');
    usePTB = 1; %input('Are you using Pychtoolbox (0/1)? ');
    
    if usePTB        
        %fn='iiyama_1280x1024_20070504.lut';% input('    File name that contains the ''gammatable'' matrix for this display: ','s');
        %load(fn,'-mat')
        screenid=max(Screen('Screens'));  
        AssertOpenGL;   % give warning if the psychotoolbox is not based on OpenGL
        [win, winRect] = Screen('OpenWindow', screenid, [128 128 128]); 
        [gammatable, dacbits, reallutsize] = Screen('ReadNormalizedGammaTable', win);
        linear_gammtable=repmat(linspace(0,((reallutsize-1)./reallutsize),reallutsize)',1,3);
        %Screen('LoadNormalizedGammaTable', win, InvGammaTable);
        Screen('LoadNormalizedGammaTable', win, linear_gammtable);
        
        Width=winRect(3);
        Height=winRect(4);
        x0=round(Width./2);
        y0=round(Height./2);
        %ColorResolution=size(InvGammaTable,1); % should be 256 for a 8 bit card
        ColorResolution=size(linear_gammtable,1);
        spot_diam=300;%300
    end

    nomsyncfreq = ''; % no syncronization (DC measurement)
    if sync
        disp('waiting for monitor to turn on...')
        pause(5)
        fprintf(s,'f'), pause(1)
        out = fscanf(s, '%d,%f');
        if isempty(out), disp('Error - PR650 may not be in remote mode. Exiting...'), fclose(s); delete(s); clear s; return;, end
        if out(1)~=0, disp('Error - Refresh rate could not be measured. Exiting...'), fclose(s); delete(s); clear s; return;, end
        fprintf('Measured refresh rate = %3.2f\n', out(2))
        nomsyncfreq='1'; % use measured frequency

    end
    if useND
        Sstring = ['S1,2,,,' nomsyncfreq ',0,' num2str(avgcnt) ',1'];
    else
        Sstring = ['S1,,,,' nomsyncfreq ',0,' num2str(avgcnt) ',1'];
    end
    fprintf(s,Sstring), pause(1)
    ok = fscanf(s, '%d');
    if isempty(ok), disp('Error - PR650 may not be in remote mode. Exiting...'), fclose(s); delete(s); clear s; return;, end
    if ok~=0, disp('Error - Invalid PR650 setting string. Exiting...'), fclose(s); delete(s); clear s; return;, end
    col='k';
    while 1
        if usePTB
            whichgun = input('Measure (r)ed, (g)reen, (b)lue (w)hite, e(x)it: ', 's');
            if whichgun == 'x'
                break
            end
            lumlev =    input('                Measure at level (0 to 1): ');
            level = lumlev .* (ColorResolution-1);
            color.a = 0;
            color.b = 0;
            color.c = 0;
            switch whichgun
                case 'r'
                    color.a = level; col = 'r';
                case 'g'
                    color.b = level; col = 'g';
                case 'b'
                    color.c = level; col = 'b';
                case 'w'
                    color.a = level; col = 'k';
                    color.b = level;
                    color.c = level;
                    %           case 'eew'
                    %             if ~exist('RGB2LMSMatrix','var')
                    %                tmp=input('Color calibration file name with path: ','s');
                    %                eval(['load ''' tmp ''''])
                    %                global outofgamut
                    %                InitColor_true(RGB2LMSMatrix, DARKLMSVector, [], [])
                    %             end
                    %             yrb2rgb_true([lumlev 0.7 1.0]');
                    %             RGB = yrb2rgb_true([lumlev 0.7 1.0]').* (ColorResolution-1);
                    %             if outofgamut
                    %                 beep;
                    %                 disp('The color (or luminance) you requested is out of gamut. Sorry.')
                    %                 disp('Try again...')
                    %                 continue
                    %             end
                    %             color.a = RGB(1); col = 'c';
                    %             color.b = RGB(2);
                    %             color.c = RGB(3);
            end
            
            colorvector = [color.a color.b color.c]% [ 51 127.5 204];
            Screen('FillOval', win, colorvector, [x0-spot_diam./2 y0-spot_diam./2 x0+spot_diam./2 y0+spot_diam./2] );
            WaitSecs(0.1);
            Screen('Flip', win);
            
        end
        disp('Press any key to measure ...')
        pause
        disp('Measuring ...')
        fprintf(s, 'm5'), while s.BytesAvailable<M5BYTES; s.BytesAvailable;end;
        disp('Measurement complete ...')
        out = fscanf(s, '%d,%d');
        if out(1)~=0
            out
            disp('Bad measurement. Try again...')
            flushinput(s), flushoutput(s), continue
        end
        intensity = fscanf(s, '%E'); % integrated intensity in units specified above
        switch out(2)
            case 0, fprintf('Integrated spectral radiance = %g W/m^2/sr\n', intensity)
            case 1, fprintf('Integrated spectral irradiance = %g W/m^2\n', intensity)
            case 2, disp('Error - Uncalibrated measurement. Exiting...'), fclose(s); delete(s); clear s; return;
            otherwise disp('Error - Measurement error. Exiting...'), fclose(s); delete(s); clear s; return;
        end
        i=1;
        while s.BytesAvailable>0
            data(i,:) = fscanf(s,'%f,%E')';
            i=i+1;
        end
        beep, pause(0.5), beep
        plot(data(:,1), data(:,2),[col '.-']), hold on, figure(gcf)
        savname = input('Good measurement. Full name for text file: ', 's');
        eval(['save ' savname ' -ascii -double data'])
        str=input('Press ''Enter'' to measure again, ''x'' and ''Enter'' to exit:','s');
        if ~isempty(str), break, end
    end
 fclose(s); delete(s); clear s
 Screen('CloseAll')
 %cs;
catch
    fclose(s); delete(s); clear s
    Screen('CloseAll')
    %cs;
end
if exist('RGB2LMSMatrix','var')
    i=1;
    while 1
        if ~input('Do you want to calculate cone chromaticity of equal-energy white measurements (0/1)? '), break, end
        eewfile = input('EEW measurement file name: ', 's');
        eewmeas = load(eewfile);
        % interpolate the data to 1 nm steps
        eew = interp1(eewmeas(:,1), eewmeas(:,2), (380:780)');
        if ~exist('log_lms','var')
            disp(' ')
            disp('Choose cone sensitivities (see www.cvrl.org)')
            disp('The following are available:')
            disp(' ')
            disp(' Stockman, MacLeod and Johnson (1993)')
            disp(' ')
            disp('   smj2.txt - 2-deg fundamentals based on the Stiles and Burch 2-deg CMFs')
            disp('   smj10.txt - 10-deg fundamentals based on the unadjusted CIE 10-deg CMFs ')
            disp('   smj2_10.txt - 2-deg fundamentals based on the CIE 10-deg CMFs adjusted to 2-deg')
            disp('  ')
            disp(' Stockman and Sharpe (2000)')
            disp(' ')
            disp('   ss2_10e_1.txt - 2-deg fundamentals based on the Stiles and Burch 10-deg CMFs adjusted to 2-deg')
            disp('   ss10e_1.txt - 10-deg fundamentals based on the  Stiles and Burch 10-deg CMFs')
            disp(' ')
            disp('Enter the full name of the cone fundamental file you would like to use,')
            cone_fund = input('smj2.txt suggested: ', 's');
            log_lms = dlmread(cone_fund);
            disp(' ')
            % Interpolate
            lms = 10.^interp1(log_lms(:,1), log_lms(:,2:4), (380:780)', 'linear', 'extrap');
            % Scale cone sensitivities so that equal energy white has r=L/(L+M)=0.7,
            % and b=S/(L+M)=1.0 (L = 0.7, M = 0.3, S = 1.0)
            lms(:,1) = lms(:,1) .* 0.7 ./ sum(lms(:,1));
            lms(:,2) = lms(:,2) .* 0.3 ./ sum(lms(:,2));
            lms(:,3) = lms(:,3) .* 1.0 ./ sum(lms(:,3));
            %             % check that eew has r=0.7, b=1.0:
            %             r_eew = sum(lms(:,1))./(sum(lms(:,1))+sum(lms(:,2)))
            %             b_eew = sum(lms(:,3))./(sum(lms(:,1))+sum(lms(:,2)))
        else
            disp(['Using ' cone_fund ' cone fundamentals...'])
        end
        eewlms=lms'*eew;
        Y=sum(eewlms(1:2));
        r = eewlms(1)./Y;
        b = eewlms(3)./Y;
        [Y r b]
        if i==1,
            h2=figure;
            plot([0.7 0.7], [0.1 10],'k-')
            plot([0.3 1.0], [1.0 1.0],'k-')
            axis([0.65 0.75 0.5 1.5])
            axis square, grid on
        end
        i=i+1;
        hold on, plot(r, b,'k*')
        text(r,b,sprintf('%1.3f', Y))
    end
end
