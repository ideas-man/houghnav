function varargout = gui3(varargin)
% GUI3 MATLAB code for gui3.fig
%      GUI3, by itself, creates a new GUI3 or raises the existing
%      singleton*.
%
%      H = GUI3 returns the handle to a new GUI3 or the handle to
%      the existing singleton*.
%
%      GUI3('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI3.M with the given input arguments.
%
%      GUI3('Property','Value',...) creates a new GUI3 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui3_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui3_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui3

% Last Modified by GUIDE v2.5 04-Mar-2016 16:04:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui3_OpeningFcn, ...
                   'gui_OutputFcn',  @gui3_OutputFcn, ...
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


% --- Executes just before gui3 is made visible.
function gui3_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui3 (see VARARGIN)

% Choose default command line output for gui3
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui3 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui3_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in STST_button.
function STST_button_Callback(hObject, eventdata, handles)
% hObject    handle to STST_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
main_cam = webcam(1);
axes(handles.axes1);
frame = snapshot(main_cam);
img = image(frame);
sector = [];
perfTime=[];
for idx=1:100
    tic
    frame = snapshot(main_cam);
    set(img, 'CData', frame)
    
    [ res_x, res_y ] = hough_lines( frame );

     if(res_x < 0 || res_y < 0 || res_x > 640 || res_y > 480)
         hold on, plot(handles.axes1, 320, 240,'+y', 'MarkerSize',24)
         hold off
     end;
     if (res_x ==0 && res_y ==0)
         hold on, plot(handles.axes1, res_x, res_y,'+b', 'MarkerSize',24)
         hold off
     end;
     if (res_x > 0 && res_y > 0 && res_x < 640 && res_y < 480)
         hold on, plot(handles.axes1, res_x, res_y,'+r', 'MarkerSize',24)
         hold off
     end;
     
sector (idx) = 1*(+(res_x<0)) + 2*(+(res_x>0 && res_x<300))...
       + 3*(+(res_x>=300 && res_x<=340))+...
       4*(+(res_x>340 && res_x<640)) + 5*(+(res_x>640))...
       + 6*(+(res_x == 0 && res_y ==0));
   
   perfTime(idx) = toc
   
   set(handles.FPS_value, 'String', num2str(sum(perfTime)/idx));
   
   set(handles.Ll_value, 'String', num2str(sum(sector==1)));
   set(handles.L_value, 'String', num2str(sum(sector==2)));
   set(handles.F_value, 'String', num2str(sum(sector==3)));
   set(handles.R_value, 'String', num2str(sum(sector==4)));
   set(handles.Rr_value, 'String', num2str(sum(sector==5)));
   set(handles.I_value, 'String', num2str(sum(sector==6)));
end;
