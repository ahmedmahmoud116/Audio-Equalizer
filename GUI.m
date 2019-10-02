function varargout = GUI(varargin)
% GUI MATLAB code for GUI.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI

% Last Modified by GUIDE v2.5 13-May-2019 02:13:05

% Begin initialization code - DO NOT EDIT

%initialization of GUI
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_OutputFcn, ...
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


% --- Executes just before GUI is made visible.
function GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI (see VARARGIN)
  handles.count = 0; %%counter to output the figures only when the user click play
vol = 2.5;  %A default value of volume
set(handles.volume,'value',vol);
% Choose default command line output for GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in browse.
%a button used to load the audio file into the program
function browse_Callback(hObject, eventdata, handles)
% hObject    handle to browse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename pathname] = uigetfile({'*.wav'},'File Selector'); %we can make it wav  
handles.fullpathname = strcat(pathname, filename);
set(handles.address, 'String',handles.fullpathname) %showing fullpathname
guidata(hObject,handles)


%a function responsible for handling the filtering process
function play_equalizer(hObject, handles)
global player;

handles.count =  handles.count+1; %%increase counter to output the figure only in play
[handles.y,handles.Fs] = audioread(handles.fullpathname); %read both the audio matrix and the sampling frequency
handles.Volume=get(handles.volume,'value'); %get the volume
handles.g1=get(handles.slider1,'value');  %get the gain in DB for each band  
handles.g2=get(handles.slider3,'value');   
handles.g3=get(handles.slider2,'value');    
handles.g4=get(handles.slider4,'value');
handles.g5=get(handles.slider9,'value');
handles.g6=get(handles.slider8,'value');
handles.g7=get(handles.slider7,'value');   
handles.g8=get(handles.slider6,'value');   
handles.g9=get(handles.slider5,'value');   
set(handles.text25, 'String',handles.g1);  %output the text label for the value of gain which the user choose
set(handles.text26, 'String',handles.g2);   
set(handles.text27, 'String',handles.g3);   
set(handles.text20, 'String',handles.g4);   
set(handles.text28, 'String',handles.g5);   
set(handles.text29, 'String',handles.g6);  
set(handles.text30, 'String',handles.g7);   
set(handles.text31, 'String',handles.g8);  
set(handles.text32, 'String',handles.g9);   

duration = length(handles.y)/handles.Fs;
Fvec = linspace(-handles.Fs/2,handles.Fs/2,duration*handles.Fs); %frequency base vector
handles.Fs1 = handles.Fs; %to store the original FS of the file

if(isempty(get(handles.edit5,'String')))
    f = msgbox('Please Choose A Sample Rate'); %pops up when the sampling rate field is empty
else
handles.Fs = str2double(get(handles.edit5,'String')); %take Output sample rate from user
end

%checking radio buttons for FIR or IIR filters
if handles.IIR.Value == 1
    %handling IIR filtering
    %lowpass
    N = 16; %assume the order of filters is 16
    cutoff= 170;
    d1 = fdesign.lowpass('N,Fc',N,cutoff/(handles.Fs/2));
    Hbutter1 = design(d1,'butter');
    y1 = 10^(handles.g1/20)*filter(Hbutter1,handles.y); %which convert the db to unitless
    Y1 = fftshift(fft(y1));%convert to frequency domain
    if(handles.count == 1)
    fvtool(Hbutter1);%to plot the magnitude & phase responses ; pzmap ; impulse & step responses of each band
    end
    
    %bandpass1
    f1 = 170;
    f2 = 310;
    d2= fdesign.bandpass('N,Fc1,Fc2',N,f1/(handles.Fs/2),f2/(handles.Fs/2));
    Hbutter2= design(d2,'butter');
    y2 = 10^(handles.g2/20)*filter(Hbutter2,handles.y);
    Y2 = fftshift(fft(y2));
    if(handles.count == 1)
    fvtool(Hbutter2);
    end
    
    %bandpass2
    f3 = 310;
    f4 = 600;
    d3= fdesign.bandpass('N,Fc1,Fc2',N,f3/(handles.Fs/2),f4/(handles.Fs/2));
    Hbutter3=design(d3,'butter');
    y3 = 10^(handles.g3/20)*filter(Hbutter3,handles.y);
    Y3 = fftshift(fft(y3));
    if(handles.count == 1)
    fvtool(Hbutter3);
    end
    
    %bandpass3
    f5 = 600;
    f6 = 1000;
    d4= fdesign.bandpass('N,Fc1,Fc2',N,f5/(handles.Fs/2),f6/(handles.Fs/2));
    Hbutter4=design(d4,'butter');
    y4 = 10^(handles.g4/20)*filter(Hbutter4,handles.y);
    Y4 = fftshift(fft(y4));
    if(handles.count == 1)
    fvtool(Hbutter4);
    end
    
    %bandpass4
    f7 = 1000;
    f8 = 3000;
    d5= fdesign.bandpass('N,Fc1,Fc2',N,f7/(handles.Fs/2),f8/(handles.Fs/2));
    Hbutter5=design(d5,'butter');
    y5 = 10^(handles.g5/20)*filter(Hbutter5,handles.y);
    Y5 = fftshift(fft(y5));
    if(handles.count == 1)
    fvtool(Hbutter5);
    end
    
    %bandpass5
    f9 = 3000;
    f10 = 6000;
    d6= fdesign.bandpass('N,Fc1,Fc2',N,f9/(handles.Fs/2),f10/(handles.Fs/2));
    Hbutter6=design(d6,'butter');
    y6= 10^(handles.g6/20)*filter(Hbutter6,handles.y);
    Y6 = fftshift(fft(y6));
    if(handles.count == 1)
    fvtool(Hbutter6);
    end
    
    %bandpass6
    f11 = 6000;
    f12 = 12000;
    d7= fdesign.bandpass('N,Fc1,Fc2',N,f11/(handles.Fs/2),f12/(handles.Fs/2));
    Hbutter7=design(d7,'butter');
    y7= 10^(handles.g7/20)*filter(Hbutter7,handles.y);
    Y7 = fftshift(fft(y7));
    if(handles.count == 1)
    fvtool(Hbutter7);
    end
    
    %bandpass7
    f13 = 12000;
    f14 = 14000;
    d8= fdesign.bandpass('N,Fc1,Fc2',N,f13/(handles.Fs/2),f14/(handles.Fs/2));
    Hbutter8=design(d8,'butter');
    y8= 10^(handles.g8/20)*filter(Hbutter8,handles.y);
    Y8 = fftshift(fft(y8));
    if(handles.count == 1)
    fvtool(Hbutter8);
    end
    
    %bandpass8
    f15 = 14000;
    f16 = 16000;
    d9= fdesign.bandpass('N,Fc1,Fc2',N,f15/(handles.Fs/2),f16/(handles.Fs/2));
    Hbutter9=design(d9,'butter');
    y9= 10^(handles.g/20)*filter(Hbutter9,handles.y);
    Y9 = fftshift(fft(y9));
    if(handles.count == 1)
    fvtool(Hbutter9);
    end
    
    %total
    handles.yT=y1+y2+y3+y4+y5+y6+y7+y8+y9; %gets the total composite signal
    if(handles.count == 1)
    fvtool(Hbutter1,Hbutter2,Hbutter3,Hbutter4,Hbutter5,Hbutter6,Hbutter7,Hbutter8,Hbutter9); %tool that plots the magnitude & phase responses ; pzmap ; impulse & step responses
    end
elseif handles.FIR.Value == 1
    % handles.FS = get(handles.text1,'String');
        %lowpass
        cut_off = 170; %cut off low pass dalama Hz
        order = 16; %assume order 16
        a = fir1(order,cut_off/(handles.Fs/2),'low'); %make fir with hamming window and the first one low pass because its from 0-170
        y1 = 10^(handles.g1/20)*filter(a,1,handles.y);        %multiply with gain in db to amplify the signal
        Y1 = fftshift(fft(y1));
        if(handles.count == 1)
         fvtool(a);
        end
        % %bandpass1
        f1 = 170;
        f2 = 310;
        b1 = fir1(order,[f1/(handles.Fs/2) f2/(handles.Fs/2)],'bandpass');    %the rest making fir with bandpass
        y2 = 10^(handles.g2/20)*filter(b1,1,handles.y);
        Y2 = fftshift(fft(y2));
        if(handles.count == 1)
        fvtool(b1);
        end
        %
        % %bandpass2
        f3 = 310;
        f4 = 600;
        b2 = fir1(order,[f3/(handles.Fs/2) f4/(handles.Fs/2)],'bandpass');
        y3 = 10^(handles.g3/20)*filter(b2,1,handles.y);
        Y3 = fftshift(fft(y3));
        if(handles.count == 1)
        fvtool(b2);
        end
        %
        % %bandpass3
        f4 = 600;
        f5 = 1000;
        b3 = fir1(order,[f4/(handles.Fs/2) f5/(handles.Fs/2)],'bandpass');
        y4 = 10^(handles.g4/20)*filter(b3,1,handles.y);
        Y4 = fftshift(fft(y4));
        if(handles.count == 1)
        fvtool(b3);
        end
        %
        % %bandpass4
        f5 = 1000;
        f6 = 3000;
        b4 = fir1(order,[f5/(handles.Fs/2) f6/(handles.Fs/2)],'bandpass');
        y5 = 10^(handles.g5/20)*filter(b4,1,handles.y);
        Y5 = fftshift(fft(y5));
        if(handles.count == 1)
        fvtool(b4);
        end
        %
        % %bandpass5
        f7 = 3000;
        f8 = 6000;
        b5 = fir1(order,[f7/(handles.Fs/2) f8/(handles.Fs/2)],'bandpass');
        y6 = 10^(handles.g6/20)*filter(b5,1,handles.y);
        Y6 = fftshift(fft(y6));
        if(handles.count == 1)
        fvtool(b5);
        end
        %
        % %bandpass6
        f9 = 6000;
        f10 = 12000;
        b6 = fir1(order,[f9/(handles.Fs/2) f10/(handles.Fs/2)],'bandpass');
        y7 = 10^(handles.g7/20)*filter(b6,1,handles.y);
        Y7 = fftshift(fft(y7));
        if(handles.count == 1)
        fvtool(b6);
        end
        %
        % %bandpass7
        f11 = 12000;
        f12 = 14000;
        b7=fir1(order,[f11/(handles.Fs/2) f12/(handles.Fs/2)],'bandpass');
        y8=10^(handles.g8/20)*filter(b7,1,handles.y);
        Y8 = fftshift(fft(y8));
        if(handles.count == 1)
        fvtool(b7);
        end
        %
        % %bandpass8
        f13 = 14000;
        f14 = 16000;
        b8=fir1(order,[f13/(handles.Fs/2) f14/(handles.Fs/2)],'bandpass');
        y9=10^(handles.g9/20)*filter(b8,1,handles.y);
        Y9 = fftshift(fft(y9));
        if(handles.count == 1)
        fvtool(b8);
        end
        
        handles.yT=y1+y2+y3+y4+y5+y6+y7+y8+y9;       %Composite signal
        if(handles.count == 1)
        fvtool(a,b1,b2,b3,b4,b5,b6,b7,b8); %tool that plots the magnitude & phase responses ; pzmap ; impulse & step responses
        end
else
    f = msgbox('Please Choose A Filter Type'); %if the user didn't choose filter type
end
        
     
player = audioplayer(handles.Volume*handles.yT, handles.Fs);

axes(handles.axes2); % Switch current axes to axes2
plot(handles.y); % Will plot into axes2
grid on
axes(handles.axes6); % Switch current axes to axes6
plot(handles.yT); % Will plot into axes6
grid on
axes(handles.axes3); % Switch current axes to axes3
plot(abs(fftshift(fft(handles.y)))); % Willss plot into axes3
grid on
axes(handles.axes7); % Switch current axes to axes7
plot(abs(fftshift(fft(handles.yT)))); % Will plot into axes7
grid on
  if(handles.count == 1)
 figure(1); %to figure each band in time domain
 subplot(3,3,1);
 plot(y1);
 ylabel('y1');
 subplot(3,3,2);
 plot(y2);
 title('Output signals in Time Domain');
 ylabel('y2');
 subplot(3,3,3);
 plot(y3);
 ylabel('y3');
 subplot(3,3,4);
 plot(y4);
 ylabel('y4');
 subplot(3,3,5);
 plot(y5);
 ylabel('y5');
 subplot(3,3,6);
 plot(y6);
 ylabel('y6');
 subplot(3,3,7);
 plot(y7);
 ylabel('y7');
 subplot(3,3,8);
 plot(y8);
 ylabel('y8');
 subplot(3,3,9);
 plot(y9);
 ylabel('y9');
  end
  if(handles.count == 1)
 figure(2); %to figure each band in frequency domain
 subplot(3,3,1);
 plot(Fvec,abs(Y1));
 ylabel('y1');
 subplot(3,3,2);
 plot(Fvec,abs(Y2));
 title('Output signals in Frequency Domain');
 ylabel('y2');
 subplot(3,3,3);
 plot(Fvec,abs(Y3));
 ylabel('y3');
 subplot(3,3,4);
 plot(Fvec,abs(Y4));
 ylabel('y4');
 subplot(3,3,5);
 plot(Fvec,abs(Y5));
 ylabel('y5');
 subplot(3,3,6);
 plot(Fvec,abs(Y6));
 ylabel('y6');
 subplot(3,3,7);
 plot(Fvec,abs(Y7));
 ylabel('y7');
 subplot(3,3,8);
 plot(Fvec,abs(Y8));
 ylabel('y8');
 subplot(3,3,9);
 plot(Fvec,abs(Y9));
 ylabel('y9');
  end
 handles.count =handles.count+1;
guidata(hObject,handles)

% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider3_Callback(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider4_Callback(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider5_Callback(hObject, eventdata, handles)
% hObject    handle to slider5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider6_Callback(hObject, eventdata, handles)
% hObject    handle to slider6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider7_Callback(hObject, eventdata, handles)
% hObject    handle to slider7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider8_Callback(hObject, eventdata, handles)
% hObject    handle to slider8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider9_Callback(hObject, eventdata, handles)
% hObject    handle to slider9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in play.
function play_Callback(hObject, eventdata, handles)
global player;
% hObject    handle to play (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
play_equalizer(hObject, handles); %call equalizer to make the composite signal
play(player);%play the sound
guidata(hObject,handles);%update the gui


% --- Executes on button press in pause.
function pause_Callback(hObject, eventdata, handles)
% hObject    handle to pause (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global player;
handles.count =  5;%to make plot only in play
play_equalizer(hObject, handles); 
pause(player);%pause the sound
guidata(hObject,handles);


% --- Executes on button press in Resume.
function Resume_Callback(hObject, eventdata, handles)
% hObject    handle to Resume (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global player;
handles.count =  5;
play_equalizer(hObject, handles); 
resume(player);%resume the sound
guidata(hObject,handles);


% --- Executes on button press in stop.
function stop_Callback(hObject, eventdata, handles)
% hObject    handle to stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global player;
handles.count =  5;
play_equalizer(hObject, handles); 
stop(player);%stop the sound
guidata(hObject,handles);


% --- Executes on slider movement.
function volume_Callback(hObject, eventdata, handles)
% hObject    handle to volume (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function volume_CreateFcn(hObject, eventdata, handles)
% hObject    handle to volume (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in save.
function save_Callback(hObject, eventdata, handles)

% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%     handles.output = hObject;

%in save we recalculate again before saving
global player;
[handles.y,handles.Fs] = audioread(handles.fullpathname);
handles.Volume=get(handles.volume,'value');
handles.g1=get(handles.slider1,'value');   %slider3 = slider 1
handles.g2=get(handles.slider3,'value');   %slider4 = slider 3
handles.g3=get(handles.slider2,'value');    
handles.g4=get(handles.slider4,'value');
handles.g5=get(handles.slider9,'value');
handles.g6=get(handles.slider8,'value');
handles.g7=get(handles.slider7,'value');   %slider10 = slider 7
handles.g8=get(handles.slider6,'value');   %slider11 = slider 6
handles.g9=get(handles.slider5,'value');   %slider6 = slider5
set(handles.text25, 'String',handles.g1);   %text16 = text 25
set(handles.text26, 'String',handles.g2);   %text19 = text 26
set(handles.text27, 'String',handles.g3);   %text20 = text 27
set(handles.text20, 'String',handles.g4);   %text21 = text 20
set(handles.text28, 'String',handles.g5);   %text22 = text 28
set(handles.text29, 'String',handles.g6);   %text23 = text 29
set(handles.text30, 'String',handles.g7);   %text24 = text 30
set(handles.text31, 'String',handles.g8);   %text25 = text 31
set(handles.text32, 'String',handles.g9);   %text26 = text 32

duration = length(handles.y)/handles.Fs;
Fvec = linspace(-handles.Fs/2,handles.Fs/2,duration*handles.Fs);
handles.Fs1 = handles.Fs;

if(isempty(get(handles.edit5,'String')))
    f = msgbox('Please Choose A Sample Rate');
else
handles.Fs = str2double(get(handles.edit5,'String')); %take Output sample rate from user
end

%checking radio buttons
if handles.IIR.Value == 1
    %lowpass
    N = 16;
    cutoff= 170;
    d1 = fdesign.lowpass('N,Fc',N,cutoff/(handles.Fs/2));
    Hbutter1 = design(d1,'butter');
    y1 = handles.g1*filter(Hbutter1,handles.y);
    Y1 = fftshift(fft(y1));
    
    %bandpass1
    f1 = 170;
    f2 = 310;
    d2= fdesign.bandpass('N,Fc1,Fc2',N,f1/(handles.Fs/2),f2/(handles.Fs/2));
    Hbutter2= design(d2,'butter');
    y2 = handles.g2*filter(Hbutter2,handles.y);
    Y2 = fftshift(fft(y2));
    
    %bandpass2
    f3 = 310;
    f4 = 600;
    d3= fdesign.bandpass('N,Fc1,Fc2',N,f3/(handles.Fs/2),f4/(handles.Fs/2));
    Hbutter3=design(d3,'butter');
    y3 = handles.g3*filter(Hbutter3,handles.y);
    Y3 = fftshift(fft(y3));
    
    %bandpass3
    f5 = 600;
    f6 = 1000;
    d4= fdesign.bandpass('N,Fc1,Fc2',N,f5/(handles.Fs/2),f6/(handles.Fs/2));
    Hbutter4=design(d4,'butter');
    y4 = handles.g4*filter(Hbutter4,handles.y);
    Y4 = fftshift(fft(y4));
    
    %bandpass4
    f7 = 1000;
    f8 = 3000;
    d5= fdesign.bandpass('N,Fc1,Fc2',N,f7/(handles.Fs/2),f8/(handles.Fs/2));
    Hbutter5=design(d5,'butter');
    y5 = handles.g5*filter(Hbutter5,handles.y);
    Y5 = fftshift(fft(y5));
    
    %bandpass5
    f9 = 3000;
    f10 = 6000;
    d6= fdesign.bandpass('N,Fc1,Fc2',N,f9/(handles.Fs/2),f10/(handles.Fs/2));
    Hbutter6=design(d6,'butter');
    y6= handles.g6*filter(Hbutter6,handles.y);
    Y6 = fftshift(fft(y6));
    
    %bandpass6
    f11 = 6000;
    f12 = 12000;
    d7= fdesign.bandpass('N,Fc1,Fc2',N,f11/(handles.Fs/2),f12/(handles.Fs/2));
    Hbutter7=design(d7,'butter');
    y7= handles.g7*filter(Hbutter7,handles.y);
    Y7 = fftshift(fft(y7));
    
    %bandpass7
    f13 = 12000;
    f14 = 14000;
    d8= fdesign.bandpass('N,Fc1,Fc2',N,f13/(handles.Fs/2),f14/(handles.Fs/2));
    Hbutter8=design(d8,'butter');
    y8= handles.g8*filter(Hbutter8,handles.y);
    Y8 = fftshift(fft(y8));
    
    %bandpass8
    f15 = 14000;
    f16 = 16000;
    d9= fdesign.bandpass('N,Fc1,Fc2',N,f15/(handles.Fs/2),f16/(handles.Fs/2));
    Hbutter9=design(d9,'butter');
    y9= handles.g9*filter(Hbutter9,handles.y);
    Y9 = fftshift(fft(y9));
    
    %total
    handles.yT=y1+y2+y3+y4+y5+y6+y7+y8+y9; 
elseif handles.FIR.Value == 1
    % handles.FS = get(handles.text1,'String');
        %lowpass
        cut_off = 170; %cut off low pass dalama Hz
        order = 16;
        a = fir1(order,cut_off/(handles.Fs/2),'low'); %make fir with hamming window and the first one low pass because its from 0-170
        y1 = handles.g1*filter(a,1,handles.y);        %multiply with gain amplify the sigY1nal
        Y1 = fftshift(fft(y1));
        % %bandpass1
        f1 = 170;
        f2 = 310;
        b1 = fir1(order,[f1/(handles.Fs/2) f2/(handles.Fs/2)],'bandpass');    %the rest making fir with bandpass
        y2 = handles.g2*filter(b1,1,handles.y);
        Y2 = fftshift(fft(y2));
        %
        % %bandpass2
        f3 = 310;
        f4 = 600;
        b2 = fir1(order,[f3/(handles.Fs/2) f4/(handles.Fs/2)],'bandpass');
        y3 = handles.g3*filter(b2,1,handles.y);
        Y3 = fftshift(fft(y3));
        %
        % %bandpass3
        f4 = 600;
        f5 = 1000;
        b3 = fir1(order,[f4/(handles.Fs/2) f5/(handles.Fs/2)],'bandpass');
        y4 = handles.g4*filter(b3,1,handles.y);
        Y4 = fftshift(fft(y4));
        %
        % %bandpass4
        f5 = 1000;
        f6 = 3000;
        b4 = fir1(order,[f5/(handles.Fs/2) f6/(handles.Fs/2)],'bandpass');
        y5 = handles.g5*filter(b4,1,handles.y);
        Y5 = fftshift(fft(y5));
        %
        % %bandpass5
        f7 = 3000;
        f8 = 6000;
        b5 = fir1(order,[f7/(handles.Fs/2) f8/(handles.Fs/2)],'bandpass');
        y6 = handles.g6*filter(b5,1,handles.y);
        Y6 = fftshift(fft(y6));
        %
        % %bandpass6
        f9 = 6000;
        f10 = 12000;
        b6 = fir1(order,[f9/(handles.Fs/2) f10/(handles.Fs/2)],'bandpass');
        y7 = handles.g7*filter(b6,1,handles.y);
        Y7 = fftshift(fft(y7));
        %
        % %bandpass7
        f11 = 12000;
        f12 = 14000;
        b7=fir1(order,[f11/(handles.Fs/2) f12/(handles.Fs/2)],'bandpass');
        y8=handles.g8*filter(b7,1,handles.y);
        Y8 = fftshift(fft(y8));
        %
        % %bandpass8
        f13 = 14000;
        f14 = 16000;
        b8=fir1(order,[f13/(handles.Fs/2) f14/(handles.Fs/2)],'bandpass');
        y9=handles.g9*filter(b8,1,handles.y);
        Y9 = fftshift(fft(y9));
        
        handles.yT=y1+y2+y3+y4+y5+y6+y7+y8+y9;       %Composite signal
else
    f = msgbox('Please Choose A Filter Type');
end 
     
player = audioplayer(handles.Volume*handles.yT, handles.Fs); %make player with the new frequency and sample rates
FileName = uiputfile('*.wav', 'Save your audio file'); %get the path of the file and file name
audiowrite(FileName, handles.yT, handles.Fs1);%then write the audio
guidata(hObject,handles);


% --- Executes on button press in FIR.
function FIR_Callback(hObject, eventdata, handles)
% hObject    handle to FIR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of FIR
set(handles.IIR,'Value',0);
guidata(hObject, handles);


% --- Executes on button press in IIR.
function IIR_Callback(hObject, eventdata, handles)
% hObject    handle to IIR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of IIR
set(handles.FIR,'Value',0);
guidata(hObject, handles);


% --- Executes on slider movement.
function slider12_Callback(hObject, eventdata, handles)
% hObject    handle to slider12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when uipanel5 is resized.
function uipanel5_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to uipanel5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
