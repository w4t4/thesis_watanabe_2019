function myMeasureMatrix = ColorCALIIGetValues_linux(ColorCALIICDCPort)
% Takes a reading. These values need to be transformed by above correction
% matrix to obtain XYZ values

% Use the 'serial' function to assign a handle to the port ColorCAL II is
% connected to. This handle (s1 in the current example) will then be used
% to communicate with the chosen port).
s1 = serial(ColorCALIICDCPort);
srl_timeout (s1, 100);

% Open the ColorCAL II port so that it is open to be communicated with.
% Communication with the ColorCAL II occurs as though it were a text file.
% Therefore to open it, use fopen.
% fopen(s1);

% whichColumn is to indicate the column the current value is to be written
% to.
whichColumn = 1;

% It can be useful to contain codes within 'try/catch' statements so that
% if the code raises an error and aborts part way, the 'catch' can be used
% to ensure any open ports are closed properly. Aborting the script without
% closing the ports properly may prevent the port from being reopened again
% in future. If this happens, just close and reopen MATLAB.
try
    
    % Commands are passed to the ColorCAL II as though they were being
    % written to a text file, using fprintf. The command MES will read
    % current light levels and and return the tri-stimulus value (to 2
    % decimal places), adjusted by the zero-level calibration values above.
    % Note the '13' represents the terminator character. 13 represents a
    % carriage return and should be included at the end of every command to
    % indicate when a command is finished.
    % fprintf(s1, ['MES' 13]);
	srl_flush(s1);
	str = ['MES' 13];
	srl_write(s1, str);
    
    % This command returns a blank character at the start of each line by
    % default that can confuse efforts to read the values. Therefore use
    % fscanf once to remove this character.
    % fscanf(s1);
    
    % To read the returned data, use fscanf, as though reading from a text
    % file.
	res = srl_read(s1, 30); % 測定結果を読む（バイトコード）：　必要な文字数をきっちり保存（30文字読むとこの関数が終わる）
	dataLine = char(res); % 結果を文字列に
    
    % The returned dataLine will be returned as a string of characters in
    % the form of 'OK00,242.85,248.11, 89.05'. In case of additional blank
    % characters before or after the relevant information, loop through
    % each character until a O is found to be sure of the start position of
    % the data.
    for k = 1:length(dataLine)
        
        % Once an O has been found, assign the start position of the
        % numbers to 5 characters beyond this (i.e. skipping th 'OKOO,')
        if dataLine(k) == 'O'
            myStart = k+5;
            
            % A comma (,) indicates the start of a value. Therefore if this
            % is found, the value is the number formed of the next 6
            % characters
        elseif dataLine(k) == ','
            myEnd = k+6;
            
            % Using k to indicate the row position and whichColumn to
            % indicate the column position, convert the 5 characters to a
            % number and assign it to the relevant position.
            myMeasureMatrix(whichColumn) = str2num(dataLine(myStart:myEnd));
            
            % reset myStart to k+7 (the first value of the next number)
            myStart = k+7;
            
            % Add 1 to the whichColumn value so that the next value will be
            % saved to the correct location.
            whichColumn = whichColumn + 1;
            
        end
    end
    
    % If an error occurs and the script aborts early, ensure ports are
    % closed to make it easier to reopen it in the future.
catch ME
    errmsg = lasterr;
    
    fprintf('\n\nSome errors occured.\n');fflush(1);
    fprintf('------ Error message ------\n');fflush(1);
    fprintf('%s\n',errmsg);fflush(1);
    fprintf('---------------------------\n');fflush(1);
    
    % use fclose to close a serial port, the same as though closing a text
    % file.
    srl_close(s1);
end

% use fclose to close a serial port, the same as though closing a text
% file.
srl_close(s1);
