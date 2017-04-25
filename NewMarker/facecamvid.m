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
handles.FaceDetector = vision.CascadeObjectDetector('FrontalFaceLBP');
handles.EyeDetector = vision.CascadeObjectDetector('EyePairBig');
handles.loop = false;
handles.debug_Mode=1;
% Set up data gathering condition
%handles.gather = false;
handles.DIVrow=20;
handles.DIVcol=20;
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
warning('off','all');

isTextStart = strcmp(hObject.String,'Start');
isTextStop = strcmp(hObject.String,'Stop');

if isTextStart
    hObject.String = 'Stop';
    cam = webcam();
    handles.loop = true; %Create stop_now in the handles structure
    guidata(hObject,handles);  %Update the GUI data
    marker = false;
    j = 0;
    frameCounter = 0;
    aCol = [];
    aRow = [];
    mCol = [];
    mRow = [];
    import java.awt.Robot;
    import java.awt.event.*;
    robot=Robot ();
    pos=get(0,'Pointerlocation');
    EyesFrame = [];
    dx=[];
    dy=[];
    nRow=[];
    nCol=[];
    videoFrame = rgb2gray((snapshot(cam)));
    %Detect face
    Face = step(handles.FaceDetector, videoFrame);
    faceCheck = size(Face);
    if faceCheck(1) > 1
        Face = Face(1,:);
    elseif faceCheck(1) < 1
        while faceCheck(1) < 1
            videoFrame = rgb2gray((snapshot(cam)));
            %Detect face
            Face = step(handles.FaceDetector, videoFrame);
            faceCheck = size(Face);
        end
        Face = Face(1,:);
    end
    cVFrame = imcrop(videoFrame, Face);
    EyesFrame = step(handles.EyeDetector, cVFrame);
    eyeCheck = size(EyesFrame);
    if eyeCheck(1) > 1
        EyesFrame = EyesFrame(1,:);
    elseif eyeCheck(1) < 1
        while eyeCheck(1) < 1
            videoFrame = rgb2gray((snapshot(cam)));
            %Detect face
            Face = step(handles.FaceDetector, videoFrame);
            faceCheck = size(Face);
            if faceCheck(1) > 1
                Face = Face(1,:);
            elseif faceCheck(1) < 1
                while faceCheck(1) < 1
                    videoFrame = rgb2gray((snapshot(cam)));
                    %Detect face
                    Face = step(handles.FaceDetector, videoFrame);
                    faceCheck = size(Face);
                end
                Face = Face(1,:);
            end
            cVFrame = imcrop(videoFrame, Face);
            EyesFrame = step(handles.EyeDetector, cVFrame);
            eyeCheck = size(EyesFrame);
        end
        EyesFrame = EyesFrame(1,:);
    end
    EyesBox = imcrop(cVFrame, EyesFrame);
    BAS=zeros(handles.DIVrow,handles.DIVcol);
    a=tic;
    while handles.loop
        %pause(0.25)
        c=tic;
        videoFrame = rgb2gray((snapshot(cam)));
        cVFrame = imcrop(videoFrame, Face); %For fixed detection
        
        %Detect eyes

        %Separate the two eyes
        EyesBox1 = EyesFrame;
        EyesBox1(3) = EyesBox1(3)/2;
        secCrop = EyesBox1;
        space = (secCrop(3));
        secCrop(1) = secCrop(1) + 0.15 * space;
        secCrop(3) = secCrop(3) - 0.5 * space;
        secCrop(2)= secCrop(2) + 0.25 * secCrop(4);
        secCrop(4) = secCrop(4) * 0.4;
        videoRightEye = imcrop(cVFrame,secCrop);
        
        %Interpolation, image resize      
        imClass = class(videoRightEye);
        [x y] = meshgrid(1:size(videoRightEye,2), 1:size(videoRightEye,1));
        [xi yi] = meshgrid(1:0.3:size(videoRightEye,2), 1:0.3:size(videoRightEye,1));
        imClass;
        try
            videoRightEye = cast(interp2(x,y,double(videoRightEye),xi,yi,'linear'),imClass);
        catch
        end
        vRightEye = videoRightEye;
        %normalizes gray scale
        darkCol = min(min(videoRightEye));
        videoRightEye = videoRightEye - darkCol;
        videoRightEye(find(videoRightEye>12)) = 255;
        %make data double precision
        z = double(videoRightEye);
        %average three frames


        [x y]=ndgrid(1:size(z,1),1:size(z,2));
        %turns x,y, and z into single column vectors so that the fit function
        %can be used to plot the data
        [x1,y1,z1] = prepareSurfaceData(x,y,z);
        %plots the data using curve fitting
        sf=fit([x1,y1],z1,'poly25');
        z=sf(x,y);
        %sets the corners to 255
        %z(find(x<0.2*size(x,1) | y<0.4*size(y,1)| x>0.8*size(x,1) | y>0.8*size(y,2)))=255;
        %find minimum of the curve
        [row,col]=find(z==min(min(z)));
        %marker = true;        

        %When gather data button is pressed, find position data
        %normalized to 100pxs regardless of image resolution.
        %if handles.gather
        cFrameSize = size(vRightEye);
        height = cFrameSize(1);
        width = cFrameSize(2);
        normalWidth = 1920;
        normalHeight = 1080;
        wRatio = normalWidth/width;
        hRatio = normalHeight/height;
        normalCol = wRatio*col;
        normalRow = hRatio*row;

        aCol = [aCol, normalCol];
        aRow = [aRow, normalRow];
        %insert marker cluster
        for d=1:length(aCol)
        %d=length(aCol);
            mCol = round(aCol./wRatio);
            mRow = round(aRow./hRatio);
            tt1=mRow(d);
            tt2=mCol(d);
            try
                vRightEye(tt1,tt2)=255;
            catch
            end
        end
        dx=[dx mCol(1)-mCol(length(mCol))];
        dy=[dy mRow(1)-mRow(length(mRow))];
        axes(handles.axes2);
        cla(handles.axes2);
        %display image on axes 2
        imagesc(fliplr(vRightEye)); colormap gray

%Displays grid. If program lags, comment out.
%         for i=1:handles.DIVrow
%             line([0 width], [(i-1)*height/handles.DIVrow+1 (i-1)*height/handles.DIVrow+1],'Color','r');
%         end
%         for i=1:handles.DIVcol
%             line( [(i-1)*width/handles.DIVcol+1 (i-1)*width/handles.DIVcol+1], [0 height],'Color','r');
%         end
        
%%%%%         BAS=patchandmovemouse(mRow(d),mCol(d),width,height,BAS,handles.DIVrow,handles.DIVcol);
       
        %Sample Grid
        grid on;
        handles.axes2.GridColor = 'w';
        handles = guidata(hObject);
               
        %Once enough markers are found, output average position
        %data with mins and max.
%         j = j + 1;
%         if  j==60
%             handles.gather = false;
%             j = 0;
%             averageCol = mean(aCol)  %Column for X coordinate
%             maxCol = max(aCol)
%             minCol = min(aCol)
%             averageRow = mean(aRow) %Row for Y coordinate
%             maxRow = max(aRow)
%             minRow = min(aRow)
%             hObject.String = 'Start';
%             handles.loop = false;
%             guidata(hObject, handles);
%         end
%imoverlay
b=toc(a);
        if b>=1.5
                X=mean(dx(2:length(dx)));
                Y=mean(dy(2:length(dy)));
                try
                    %nCol=[nCol mCol(1)+round(X)];
                    %nRow=[nRow mRow(1)+round(Y)];
                    BW=zeros(size(vRightEye)); 
                    BW(mRow(1)-round(Y),mCol(1)-round(X))=1;
                    image=imoverlay(vRightEye,BW,'red');
                      %vRightEye(mRow(1)+round(Y),mCol(1)+round(X))=70;
                catch
                end
                axes(handles.axes2);
                try
                    imagesc(fliplr(image));
                catch
                    %imagesc(fliplr(vRightEye)); 
                end
                %pos = [normalWidth - (mCol(1)-round(X))*wRatio + 10, (mRow(1)-round(Y))*hRatio];
                %robot.mouseMove(pos(1),pos(2));
                
                dx=[];
                dy=[];
                aCol=[];
                aRow=[];
                a=tic;
        end
        e=toc(c);
        set(handles.text5, 'String', num2str(1/e));
        handles = guidata(hObject);  %Get the newest GUI data
        %             catch
        %             end
    end
    elseif isTextStop
        hObject.String = 'Start';
        handles.loop = false;
        guidata(hObject, handles);
    end
end