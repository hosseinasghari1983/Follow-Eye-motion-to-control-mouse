function varargout = facecamvid(varargin)
% FACECAMVID MATLAB code for facecamvid.fig
%      FACECAMVID, by itself, creates a new FACECAMVID or raises the existing
%      singleton*.
%
%      H = FACECAMVID returns the handle to a new FACECAMVID or the handle to
%      the existing singleton*.
%
%      FACECAMVID('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FACECAMVID.M with the given input arguments.
%
%      FACECAMVID('Property','Value',...) creates a new FACECAMVID or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before facecamvid_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to facecamvid_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help facecamvid

% Last Modified by GUIDE v2.5 06-Oct-2016 21:04:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @facecamvid_OpeningFcn, ...
                   'gui_OutputFcn',  @facecamvid_OutputFcn, ...
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


% --- Executes just before facecamvid is made visible.
function facecamvid_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to facecamvid (see VARARGIN)

handles.faceDetector = vision.CascadeObjectDetector();
handles.LeftEyeDetector = vision.CascadeObjectDetector('LeftEye');
handles.RightEyeDetector = vision.CascadeObjectDetector('RightEye');

handles.loop = false;
% Choose default command line output for facecamvid
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes facecamvid wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = facecamvid_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Create the webcam object.
cam = webcam();

% Capture one frame to get its size.
videoFrame = snapshot(cam);
frameSize = size(videoFrame);


handles.loop = true; %Create stop_now in the handles structure
guidata(hObject,handles);  %Update the GUI data


while handles.loop
    %Wait for a 16 fps framerate.
    pause(0.0625);
    % Get the next frame.    
    videoFrame = snapshot(cam);
    %Display in first figure.
    axes(handles.axes1);
    imshow(videoFrame);
    %Detect face and display modified image.
    videoFrameFace = videoFrame;
    facebox = step(handles.faceDetector, videoFrameFace);
    videoOut2 = insertShape(videoFrameFace,'rectangle',facebox,'LineWidth', 3);
    axes(handles.axes2);
    imshow(videoOut2);
    %Detect eyes and display modified image.
    videoFrameEyes = videoFrame;    
    LeftEyeBox = step(handles.LeftEyeDetector, videoFrameEyes);
    videoOneEye = insertShape(videoFrameEyes,'rectangle',LeftEyeBox,'LineWidth', 3);
    RightEyeBox = step(handles.RightEyeDetector, videoFrameEyes);
    videoOut3 = insertShape(videoOneEye,'rectangle',RightEyeBox,'LineWidth', 3);
    axes(handles.axes3);
    imshow(videoOut3);
    
    handles = guidata(hObject);  %Get the newest GUI data    

end



% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.loop = false;
guidata(hObject, handles); % Update handles structure


