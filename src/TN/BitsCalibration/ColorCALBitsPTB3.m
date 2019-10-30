function varargout = ColorCALBitsPTB3(varargin)
% COLORCALBITSPTB3 M-file for ColorCALBitsPTB3.fig
%      COLORCALBITSPTB3, by itself, creates a new COLORCALBITSPTB3 or raises the existing
%      singleton*.
%
%      H = COLORCALBITSPTB3 returns the handle to a new COLORCALBITSPTB3 or the handle to
%      the existing singleton*.
%
%      COLORCALBITSPTB3('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in COLORCALBITSPTB3.M with the given input arguments.
%
%      COLORCALBITSPTB3('Property','Value',...) creates a new COLORCALBITSPTB3 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before udtmeasBitsPTB3_menu_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ColorCALBitsPTB3_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ColorCALBitsPTB3

% Last Modified by GUIDE v2.5 25-Apr-2010 19:04:04

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ColorCALBitsPTB3_OpeningFcn, ...
                   'gui_OutputFcn',  @ColorCALBitsPTB3_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before ColorCALBitsPTB3 is made visible.
function ColorCALBitsPTB3_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ColorCALBitsPTB3 (see VARARGIN)

% Choose default command line output for ColorCALBitsPTB3
handles.output = hObject;

% --- initializaing GUI and parameters ---
% initialize_gui(hObject, handles, false);
initialize_gui_userparams(hObject, handles, false);


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ColorCALBitsPTB3 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ColorCALBitsPTB3_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --------------------------------------------------------------------
% Edit Text Process
% --------------------------------------------------------------------
% --------------------------------------------------------------------
function wf_Callback(hObject, eventdata, handles)
% hObject    handle to wf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of wf as text
%        str2double(get(hObject,'String')) returns contents of wf as a double

global WORKING_FOLDER;

handles.metricdata.wf = get(hObject, 'String');
WORKING_FOLDER = handles.metricdata.wf;
save_GUIparameters;

% Save the new value
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function wf_CreateFcn(hObject, eventdata, handles)
% hObject    handle to wf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function ifn_Callback(hObject, eventdata, handles)
% hObject    handle to ifn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ifn as text
%        str2double(get(hObject,'String')) returns contents of ifn as a double

global INPUT_FILE_NAME;

handles.metricdata.ifn = get(hObject, 'String');
INPUT_FILE_NAME = handles.metricdata.ifn;
save_GUIparameters;

% Save the new value
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function ifn_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ifn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function ofn_Callback(hObject, eventdata, handles)
% hObject    handle to ofn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ofn as text
%        str2double(get(hObject,'String')) returns contents of ofn as a double

global OUTPUT_FILE_NAME;

handles.metricdata.ofn = get(hObject, 'String');
OUTPUT_FILE_NAME = handles.metricdata.ofn;
save_GUIparameters;

% Save the new value
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function ofn_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ofn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function nol_Callback(hObject, eventdata, handles)
% hObject    handle to nol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nol as text
%        str2double(get(hObject,'String')) returns contents of nol as a double

global NUMBER_OF_LEVELS;

NUMBER_OF_LEVELS = str2double(get(hObject, 'String'));
if isnan(NUMBER_OF_LEVELS) || NUMBER_OF_LEVELS<3
    set(hObject, 'String', 256);
    NUMBER_OF_LEVELS = 256;
    errordlg('Input must be a number over 3','Error');
end

save_GUIparameters;
esttime(handles);

% Save the new value
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function nol_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function spl_Callback(hObject, eventdata, handles)
% hObject    handle to spl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of spl as text
%        str2double(get(hObject,'String')) returns contents of spl as a double

global SAMPLES_PER_LEVEL;

SAMPLES_PER_LEVEL = str2double(get(hObject, 'String'));
if isnan(SAMPLES_PER_LEVEL) || SAMPLES_PER_LEVEL<1
    set(hObject, 'String', 10);
    SAMPLES_PER_LEVEL = 10;
    errordlg('Input must be a number over 1','Error');
end

save_GUIparameters;
esttime(handles);

% Save the new value
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function spl_CreateFcn(hObject, eventdata, handles)
% hObject    handle to spl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --------------------------------------------------------------------
% Push Button Process
% --------------------------------------------------------------------
% --- Executes on button press in ifsearch.
function ifsearch_Callback(hObject, eventdata, handles)
% hObject    handle to ifsearch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global WORKING_FOLDER;

fn = uigetdir;
if fn ~= 0; 
    handles.metricdata.wf = fn;
    WORKING_FOLDER = handles.metricdata.wf;
    set(handles.wf, 'String', handles.metricdata.wf);
end
save_GUIparameters;

% Save the new value
guidata(hObject,handles)


% --- Executes on button press in Reset.
function Reset_Callback(hObject, eventdata, handles)
% hObject    handle to Reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

initialize_gui(gcbf, handles, true);


% --- Executes on button press in Measure.
function Measure_Callback(hObject, eventdata, handles)
% hObject    handle to Measure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


ColorCALBitsPTB3_start;



% --------------------------------------------------------------------
% Radio Button Process
% --------------------------------------------------------------------
% --------------------------------------------------------------------
function Mode_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to Mode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global MODE;

if hObject == handles.g
    MODE = 'g';
elseif hObject == handles.c
    MODE = 'c';
end
save_GUIparameters;


% --------------------------------------------------------------------
function gcm_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to gcm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global GAMMA_CORRECTION_METHOD;

if hObject == handles.LUT
    GAMMA_CORRECTION_METHOD = '1';
elseif hObject == handles.iLUT
    GAMMA_CORRECTION_METHOD = '2';
elseif hObject == handles.Fitting
    GAMMA_CORRECTION_METHOD = '3';
end
save_GUIparameters;


% --------------------------------------------------------------------
function shutdown_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to shutdown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global SHUTDOWN;

if hObject == handles.Yes
    SHUTDOWN = 'y';
elseif hObject == handles.No
    SHUTDOWN = 'n';
end
save_GUIparameters;


% --------------------------------------------------------------------
% Check Box
% --------------------------------------------------------------------
% --- Executes on button press in tl.
function tl_Callback(hObject, eventdata, handles)
% hObject    handle to tl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tl
global TL;

TL = get(hObject,'Value');
save_GUIparameters;



% --------------------------------------------------------------------
% Estimate the timetext
% --------------------------------------------------------------------
function time = esttime(handles)

global NUMBER_OF_LEVELS;
global SAMPLES_PER_LEVEL;

time = NUMBER_OF_LEVELS.*SAMPLES_PER_LEVEL.*6;  % measured by a STOP WATCH!
str = sprintf('%3.1f minutes, or %2.2f hours.',time./60,time./3600);

set(handles.timetext, 'String', str);



% --------------------------------------------------------------------
% Initialization Process (use user parameters)
% --------------------------------------------------------------------
function initialize_gui_userparams(fig_handle, handles, isreset)
%If the metricdata field is present and the reset flag is false, it means
% we are we are just re-initializing a GUI by calling it from the cmd line
% while it is up. So, bail out as we dont want to reset the data.

if isfield(handles, 'metricdata') && ~isreset
    return;
end

%GLOBAL VARIABLES
global WORKING_FOLDER;
global INPUT_FILE_NAME;
global OUTPUT_FILE_NAME;
global NUMBER_OF_LEVELS;
global SAMPLES_PER_LEVEL;
global MODE;
global GAMMA_CORRECTION_METHOD;
global SHUTDOWN;
global infostring;
global TL;

load('ColorCALBitsPTB3_userparams.mat', '-mat');

%Set to Initial conditions
handles.metricdata.wf = WORKING_FOLDER;
set(handles.wf, 'String', handles.metricdata.wf);

handles.metricdata.ifn = INPUT_FILE_NAME;
set(handles.ifn, 'String', handles.metricdata.ifn);

handles.metricdata.ofn = OUTPUT_FILE_NAME;
set(handles.ofn, 'String', handles.metricdata.ofn);

handles.metricdata.nol = num2str(NUMBER_OF_LEVELS);
set(handles.nol, 'String', handles.metricdata.nol);

handles.metricdata.spl = SAMPLES_PER_LEVEL;
set(handles.spl, 'String', handles.metricdata.spl);

switch MODE
    case 'g'
       set(handles.Mode, 'SelectedObject', handles.g);
    case 'c'
       set(handles.Mode, 'SelectedObject', handles.c);
end

switch GAMMA_CORRECTION_METHOD
    case '1'
        set(handles.gcm, 'SelectedObject', handles.LUT);
    case '2'
        set(handles.gcm, 'SelectedObject', handles.iLUT);
    case '3'
        set(handles.gcm, 'SelectedObject', handles.Fitting);
end

switch SHUTDOWN
    case 'n'
        set(handles.shutdown, 'SelectedObject', handles.No);
    case 'y'
        set(handles.shutdown, 'SelectedObject', handles.Yes);
end

switch TL
    case 0
        set(handles.tl,'Value',0);
    case 1
        set(handles.tl,'Value',1);
end


set(handles.infotext, 'String', ' ');

% set up strings for infotext
infostring = cell(16,1);
for i=1:16; infostring{i}='empty-'; end;

% estimate timetext needed
esttime(handles);

% Update handles structure
guidata(handles.figure1, handles);



% --------------------------------------------------------------------
% Initialization Process (Reset Parameters)
% --------------------------------------------------------------------
function initialize_gui(fig_handle, handles, isreset)
%If the metricdata field is present and the reset flag is false, it means
% we are we are just re-initializing a GUI by calling it from the cmd line
% while it is up. So, bail out as we dont want to reset the data.

if isfield(handles, 'metricdata') && ~isreset
    return;
end

%GLOBAL VARIABLES
global WORKING_FOLDER;
global INPUT_FILE_NAME;
global OUTPUT_FILE_NAME;
global NUMBER_OF_LEVELS;
global SAMPLES_PER_LEVEL;
global MODE;
global GAMMA_CORRECTION_METHOD;
global SHUTDOWN;
global infostring;
global TL;

%Set to Initial conditions
handles.metricdata.wf = pwd;
WORKING_FOLDER = handles.metricdata.wf;
set(handles.wf, 'String', handles.metricdata.wf);

handles.metricdata.ifn = 'file_name1';
INPUT_FILE_NAME = handles.metricdata.ifn;
set(handles.ifn, 'String', handles.metricdata.ifn);

handles.metricdata.ofn = 'file_name2';
OUTPUT_FILE_NAME = handles.metricdata.ofn;
set(handles.ofn, 'String', handles.metricdata.ofn);

handles.metricdata.nol = '256';
NUMBER_OF_LEVELS = str2num(handles.metricdata.nol);
set(handles.nol, 'String', handles.metricdata.nol);

handles.metricdata.spl = '10';
SAMPLES_PER_LEVEL = str2num(handles.metricdata.spl);
set(handles.spl, 'String', handles.metricdata.spl);


set(handles.Mode, 'SelectedObject', handles.g);
set(handles.gcm, 'SelectedObject', handles.LUT);
set(handles.shutdown, 'SelectedObject', handles.No);
MODE = 'g';
GAMMA_CORRECTION_METHOD = '1';
SHUTDOWN = 'n';

TL = 0;
set(handles.tl,'Value',0);


set(handles.infotext, 'String', ' ');

% set up strings for infotext
infostring = cell(16,1);
for i=1:16; infostring{i}='empty-'; end;

% estimate timetext needed
esttime(handles);

% Update handles structure
guidata(handles.figure1, handles);

% save parameters
save_GUIparameters;

% --------------------------------------------------------------------
% Save Parameters
% --------------------------------------------------------------------
function save_GUIparameters(fig_handle, handles, isreset)

%GLOBAL VARIABLES
global WORKING_FOLDER;
global INPUT_FILE_NAME;
global OUTPUT_FILE_NAME;
global NUMBER_OF_LEVELS;
global SAMPLES_PER_LEVEL;
global MODE;
global GAMMA_CORRECTION_METHOD;
global SHUTDOWN;
global TL;

funcinfo = dbstack('-completenames');
l = length(funcinfo(1).file);
for i=l:-1:1
    if(funcinfo(1).file(i)=='\')
        break;
    end
end
foldername = funcinfo(1).file(1:i-1);

save([foldername, '\ColorCALBitsPTB3_userparams.mat'], 'WORKING_FOLDER', 'INPUT_FILE_NAME',...
    'OUTPUT_FILE_NAME', 'NUMBER_OF_LEVELS', 'SAMPLES_PER_LEVEL', 'MODE',...
    'GAMMA_CORRECTION_METHOD', 'SHUTDOWN', 'TL', '-mat');


















