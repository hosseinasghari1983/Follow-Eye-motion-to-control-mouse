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

% Last Modified by GUIDE v2.5 24-Jan-2017 08:16:51

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
end


% --- Executes just before facecamvid is made visible.
function facecamvid_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to facecamvid (see VARARGIN)

handles.EyeDetector = vision.CascadeObjectDetector('EyePairBig');
handles.loop = false;

% Set up data gathering condition
handles.gather = false;

% Choose default command line output for facecamvid
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes facecamvid wait for user response (see UIRESUME)
% uiwait(handles.figure1);
end


% --- Outputs from this function are returned to the command line.
function varargout = facecamvid_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Create the webcam object.

isTextStart = strcmp(hObject.String,'Start');
isTextStop = strcmp(hObject.String,'Stop');

if isTextStart
    hObject.String = 'Stop';
    cam = webcam();
    handles.loop = true; %Create stop_now in the handles structure
    guidata(hObject,handles);  %Update the GUI data
    marker = false;
    j = 0;
    aCol = [];
    aRow = [];

    while handles.loop
        %Wait for a 16 fps framerate.
        pause(0.0625);
        for k=1:3
            % Get the next frame.
            videoFrame = snapshot(cam);
            %Detect eyes 
            EyesBox = step(handles.EyeDetector, videoFrame);
            check = size(EyesBox);
            if check(1) > 1 
               EyesBox = EyesBox(2,:);
            end
            if ~isempty(EyesBox)
                %Separate the two eyes
                EyesBox(3) = EyesBox(3)/2;
                secCrop = EyesBox;
                space = 0.02*(secCrop(3) - secCrop(1));
                secCrop(1) = secCrop(1) - 0.5*space;
                secCrop(3) = secCrop(3) + 1.6*space;
                videoRightEye = imcrop(videoFrame,secCrop); 
                EyesBox(1) = EyesBox(1) + EyesBox(3);
                %Adjust crop box
                secCrop = EyesBox;
                space = 0.02*(secCrop(3) - secCrop(1));
                secCrop(1) = secCrop(1) - 1.6*space;
                secCrop(3) = secCrop(3) + 0.5*space;
                videoLeftEye = imcrop(videoFrame,secCrop);

                vRightEye=videoRightEye;
                videoRightEye = rgb2gray(videoRightEye);

                axes(handles.axes1);
                cla(handles.axes1);
                surf(videoRightEye);

                %normalizes gray scale
                darkCol = min(min(videoRightEye));
                videoRightEye = videoRightEye - darkCol;
                videoRightEye(find(videoRightEye>12)) = 255;
                %make data double precision
                z0=double(videoRightEye);
                    if k==1
                        z=z0;
                    else
                        z0=imresize(z0,size(z));
                        z=(z+z0)/2;
                        if k==3
                            [x y]=ndgrid(1:size(z,1),1:size(z,2));
                            %turns x,y, and z into single column vectors so that the fit function
                            %can be used to plot the data
                            [x1,y1,z1] = prepareSurfaceData(x,y,z);
                            %plots the data using curve fitting
                            sf=fit([x1,y1],z1,'poly25');
                            z=sf(x,y);
                            %sets the corners to 255
                            z(find(x<0.2*size(x,1) | y<0.4*size(y,1)| x>0.8*size(x,1) | y>0.8*size(y,2)))=255;
                            axes(handles.axes2);
                            cla(handles.axes2);
                            surf(x,y,z);

                            [row,col]=find(z==min(min(z)));
                            marker = true;
                            
                            %inserts marker on the minimum (on the original image
                            %vRightEye=insertMarker(vRightEye,[col,row]);
                            
                        end
                    end
                
                axes(handles.axes4);
                cla(handles.axes4);
                if marker
                    vRightEye=insertMarker(vRightEye,[col,row]);
                end
                imshow(vRightEye);
                handles = guidata(hObject);  %Get the newest GUI data 
                
                if handles.gather           
                    cFrameSize = size(vRightEye);
                    height = cFrameSize(1);
                    width = cFrameSize(2);
                    normalWidth = 2000;
                    normalHeight = 2000;
                    wRatio = normalWidth/width;
                    hRatio = normalHeight/height;
                    normalCol = wRatio*col;
                    normalRow = hRatio*row;
                    aCol = [aCol, normalCol];
                    aRow = [aRow, normalRow];
                    j = j + 1;
                end
                if  j==10
                    handles.gather = false;
                    j = 0;
                    guidata(hObject, handles);
                    averageCol = mean(aCol)
                    maxCol = max(aCol)
                    minCol = min(aCol)
                    averageRow = mean(aRow)
                    maxRow = max(aRow)
                    minRow = min(aRow)
                end
            end
        end
    end
elseif isTextStop
    hObject.String = 'Start';
    handles.loop = false;
    guidata(hObject, handles);
end
end


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.gather = true; 
guidata(hObject, handles); %Get the newest GUI data   
end
