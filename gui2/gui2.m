function varargout = gui2(varargin)
% GUI2 MATLAB code for gui2.fig
%      GUI2, by itself, creates a new GUI2 or raises the existing
%      singleton*.
%
%      H = GUI2 returns the handle to a new GUI2 or the handle to
%      the existing singleton*.
%
%      GUI2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI2.M with the given input arguments.
%
%      GUI2('Property','Value',...) creates a new GUI2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui2

% Last Modified by GUIDE v2.5 27-Feb-2016 02:30:02

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui2_OpeningFcn, ...
                   'gui_OutputFcn',  @gui2_OutputFcn, ...
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


% --- Executes just before gui2 is made visible.
function gui2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui2 (see VARARGIN)

% Choose default command line output for gui2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in x_list.
function x_list_Callback(hObject, eventdata, handles)
% hObject    handle to x_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns x_list contents as cell array
%        contents{get(hObject,'Value')} returns selected item from x_list


% --- Executes during object creation, after setting all properties.
function x_list_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in direction_list.
function direction_list_Callback(hObject, eventdata, handles)
% hObject    handle to direction_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns direction_list contents as cell array
%        contents{get(hObject,'Value')} returns selected item from direction_list


% --- Executes during object creation, after setting all properties.
function direction_list_CreateFcn(hObject, eventdata, handles)
% hObject    handle to direction_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushStart_bt.
function pushStart_bt_Callback(hObject, eventdata, handles)
% hObject    handle to pushStart_bt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

main_cam1 = webcam(1);
axes(handles.axes1);
% frame = snapshot(main_cam1);
img = image (frame);
sector = [];
perfTime=[];
for idx = 1:50
     tic;
    f = snapshot(main_cam1);       
imshow(img), hold on

[ res_x, res_y ] = hough_lines( img );

    if(res_x <= 0 || res_y <= 0 || res_x > 640 || res_y > 480)
        hold on, plot(handles.axes1, 320, 240,'+y', 'MarkerSize',24)
    else
        hold on, plot(handles.axes1, res_x, res_y,'+r', 'MarkerSize',24)
        hold off
    end;
   sector (idx) = 1*(+(res_x<=10)) + 2*(+(res_x>10 && res_x<300))...
       + 3*(+(res_x>=300 && res_x<=340))+...
       4*(+(res_x>340 && res_x<630)) + 5*(+(res_x>=630));
          for a = 1:5
               stats(a) = sum(sector == a);
           end;
           plot(handles.axes2, 1:5, stats);
           set(handles.text6, 'String',...
               num2str((sum(sector == 3)/length(sector))*100));
           perfTime(idx)=toc;
           set(handles.text8, 'String',...
               num2str(sum(perfTime)/idx));
%     if res_x>10 && res_x<300
%         dir_list = get(handles.direction_list,'string');
%         dir_list{numel(dir_list)+1} = 'LEFT'; 
%         set(handles.direction_list,'string', dir_list );
%     end
%     if res_x>340 && res_x<630
%         dir_list = get(handles.direction_list,'string');
%         dir_list{numel(dir_list)+1} = 'RIGHT'; 
%         set(handles.direction_list,'string', dir_list );
%     end
%     if res_x>=300 && res_x<=340
%         dir_list = get(handles.direction_list,'string');
%         dir_list{numel(dir_list)+1} = 'FORWARD'; 
%         set(handles.direction_list,'string', dir_list );
%     end
%     if res_x>=630
%         dir_list = get(handles.direction_list,'string');
%         dir_list{numel(dir_list)+1} = 'RIGHT!'; 
%         set(handles.direction_list,'string', dir_list );
%     end  
%     if res_x<=10
%         dir_list = get(handles.direction_list,'string');
%         dir_list{numel(dir_list)+1} = 'LEFT!'; 
%         set(handles.direction_list,'string', dir_list );
%     end 
    toc
end
