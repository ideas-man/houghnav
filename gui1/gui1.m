function varargout = gui1(varargin)
% GUI1 MATLAB code for gui1.fig
%      GUI1, by itself, creates a new GUI1 or raises the existing
%      singleton*.
%
%      H = GUI1 returns the handle to a new GUI1 or the handle to
%      the existing singleton*.
%
%      GUI1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI1.M with the given input arguments.
%
%      GUI1('Property','Value',...) creates a new GUI1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui1

% Last Modified by GUIDE v2.5 19-Dec-2015 13:51:26

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui1_OpeningFcn, ...
                   'gui_OutputFcn',  @gui1_OutputFcn, ...
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


% --- Executes just before gui1 is made visible.
function gui1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui1 (see VARARGIN)

% Choose default command line output for gui1
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui1_OutputFcn(hObject, eventdata, handles) 
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
for idx = 1:100
    img = snapshot(main_cam1);
        tic;
imshow(img), hold on

gr = rgb2gray(img);
bw = edge(gr,'Roberts');

[H,theta,rho] = hough(bw);  %,'RhoResolution',0.5,'ThetaResolution',0.5
P = houghpeaks(H,16,'threshold',ceil(0.5*max(H(:))));
lines = houghlines(bw,theta,rho,P,'FillGap',22,'MinLength',40);
size(lines);

max_len = 0;
Diag = [];
for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   
   if abs(lines(k).theta) > 85
      plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','yellow');
   elseif abs(lines(k).theta) > 15
      plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
      plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
       Diag = [Diag,k];
   else
      plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','cyan');
   end
   
   plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
   plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

end

Cross = [];
for ii = 1: length(Diag) - 1
    for jj = ii + 1: length(Diag)
        [cr_x cr_y]  = linecross([lines(Diag(ii)).point1,lines(Diag(ii)).point2],...
                                 [lines(Diag(jj)).point1,lines(Diag(jj)).point2]);
        Cross = [Cross; cr_x cr_y];
    end
end

res_x = round(sum(Cross(:,1))/size(Cross,1));
res_y = round(sum(Cross(:,2))/size(Cross,1));
hold on,
    if(res_x <= 0 || res_y <= 0)
        hold on, plot(320, 240,'+y', 'MarkerSize',16)
    else
        hold on, plot(res_x, res_y,'+r', 'MarkerSize',16), hold off
    end;
    xCoord_list = get(handles.x_list,'string');
    xCoord_list{numel(xCoord_list)+1} = num2str(res_x);
    set(handles.x_list, 'string', xCoord_list);
    
    yCoord_list = get(handles.y_list,'string');
    yCoord_list{numel(yCoord_list)+1} = num2str(res_y);
    set(handles.y_list, 'string', yCoord_list);
  
    if res_x>10 && res_x<300
        dir_list = get(handles.direction_list,'string');
        dir_list{numel(dir_list)+1} = 'LEFT'; 
        set(handles.direction_list,'string', dir_list );
    end
    if res_x>340 && res_x<630
        dir_list = get(handles.direction_list,'string');
        dir_list{numel(dir_list)+1} = 'RIGHT'; 
        set(handles.direction_list,'string', dir_list );
    end
    if res_x>=300 && res_x<=340
        dir_list = get(handles.direction_list,'string');
        dir_list{numel(dir_list)+1} = 'FORWARD'; 
        set(handles.direction_list,'string', dir_list );
    end
    if res_x>=630
        dir_list = get(handles.direction_list,'string');
        dir_list{numel(dir_list)+1} = 'RIGHT!'; 
        set(handles.direction_list,'string', dir_list );
    end  
    if res_x<=10
        dir_list = get(handles.direction_list,'string');
        dir_list{numel(dir_list)+1} = 'LEFT!'; 
        set(handles.direction_list,'string', dir_list );
    end 
    toc

end


% --- Executes on selection change in y_list.
function y_list_Callback(hObject, eventdata, handles)
% hObject    handle to y_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns y_list contents as cell array
%        contents{get(hObject,'Value')} returns selected item from y_list


% --- Executes during object creation, after setting all properties.
function y_list_CreateFcn(hObject, eventdata, handles)
% hObject    handle to y_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
