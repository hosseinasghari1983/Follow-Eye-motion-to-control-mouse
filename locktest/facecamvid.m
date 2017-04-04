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
    oneCounter = 0;
    twoCounter = 0;
    threeCounter = 0;
    fourCounter = 0;
    fiveCounter = 0;
    sixCounter = 0;
    sevenCounter = 0;
    eightCounter = 0;
    aCol = [];
    aRow = [];
    mCol = [];
    mRow = [];
    import java.awt.Robot;
    import java.awt.event.*;
    robot=Robot ();
    pos=get(0,'Pointerlocation');
    EyesFrame = [];
    videoFrame = rgb2gray((snapshot(cam)));
    %Detect face
    Face = step(handles.FaceDetector, videoFrame);
    faceCheck = size(Face);
    if faceCheck(1) > 1
        Face = Face(2,:);
    end
    cVFrame = imcrop(videoFrame, Face);
    EyesFrame = step(handles.EyeDetector, cVFrame);
    eyeCheck = size(EyesFrame);
    if eyeCheck(1) > 1
        EyesFrame = EyesFrame(2,:);
    end
    EyesBox = imcrop(cVFrame, EyesFrame);
    
    while handles.loop
        tic;
        %pause(0.25)
%            oldFace = Face;
        videoFrame = rgb2gray((snapshot(cam)));
%        oldCVFrame = cVFrame;  %for face corr
        cVFrame = imcrop(videoFrame, Face); %For fixed detection
        
%         frameCounter = frameCounter + 1; %update face position every 20 frames
%         if frameCounter == 20
%             frameCounter = 0;
%             tempFace = step(handles.FaceDetector, videoFrame);
%             faceCheck = size(tempFace);
%             if faceCheck(1) > 1
%                 Face = tempFace(2,:);
%             elseif faceCheck(1) > 0
%                 Face = tempFace;
%             end
%             cVFrame = imcrop(videoFrame, Face);
%             tempEyesFrame = step(handles.EyeDetector, cVFrame);
%             eyeCheck = size(tempEyesFrame);
%             if eyeCheck(1) > 1
%                 EyesFrame = tempEyesFrame(2,:);
%             elseif eyeCheck(1) > 0
%                 EyesFrame = tempEyesFrame;
%             end
%         else
%             cVFrame = imcrop(videoFrame, Face)        
%         end

%         [rowsNew colsNew colorChannelsNew] = size(cVFrame); %for eye
%         %corr
%         [rowsOld colsOld colorChannelsOld] = size(oldCVFrame); 
%         if rowsNew ~= rowsOld || colsNew ~= colsOld 
%             oldCVFrame = imresize(oldCVFrame, [rowsNew colsNew]); 
%         end
% 
%         corCoef = corr2(oldCVFrame, cVFrame);
%         if corCoef > 0.1
%             tempFace = step(handles.FaceDetector, videoFrame);
%             faceCheck = size(tempFace);
%             if faceCheck(1) > 1
%                 Face = tempFace(2,:);
%             elseif faceCheck(1) > 0
%                 Face = tempFace;
%             end
%             cVFrame = imcrop(videoFrame, Face);
%             tempEyesFrame = step(handles.EyeDetector, cVFrame);
%             eyeCheck = size(tempEyesFrame);
%             if eyeCheck(1) > 1
%                 EyesFrame = tempEyesFrame(2,:);
%             elseif eyeCheck(1) > 0
%                 EyesFrame = tempEyesFrame;
%             end
%         end    



%            Face = step(handles.FaceDetector, videoFrame);
%           faceCheck = size(Face);
%           if faceCheck(1) > 1
%               Face = Face(2,:);
%           end
%           newFace = Face;
%           cVFrame = imcrop(videoFrame, newFace);
%            widthR = newFace(3)/oldFace(3);
%            heightR = newFace(4)/oldFace(4);
%            EyesFrame(1) = EyesFrame(1)*widthR;
%            EyesFrame(2) = EyesFrame(2)*heightR;
%            EyesFrame(3) = EyesFrame(3)*widthR;
%            EyesFrame(4) = EyesFrame(4)*heightR;

%            oldEyes = EyesBox; %for eye corr
        EyesBox = imcrop(cVFrame, EyesFrame);

%             [rowsNew colsNew colorChannelsNew] = size(EyesBox); %for eye
%             %corr
%             [rowsOld colsOld colorChannelsOld] = size(oldEyes); 
%             if rowsNew ~= rowsOld || colsNew ~= colsOld 
%                 oldEyes = imresize(oldEyes, [rowsNew colsNew]); 
%             end
%             
%             corCoef = corr2(oldEyes, EyesBox); %for eye corr
%             if corCoef > 0.025
%                 tempFace = step(handles.FaceDetector, videoFrame);
%                 faceCheck = size(tempFace);
%                 if faceCheck(1) > 1
%                     Face = tempFace(2,:);
%                 elseif faceCheck(1) > 0
%                     Face = tempFace;
%                 end
%                 cVFrame = imcrop(videoFrame, Face);
%                 tempEyesFrame = step(handles.EyeDetector, cVFrame);
%                 eyeCheck = size(tempEyesFrame);
%                 if eyeCheck(1) > 1
%                     EyesFrame = tempEyesFrame(2,:);
%                 elseif eyeCheck(1) > 0
%                     EyesFrame = tempEyesFrame;
%                 end
%             end       

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
        %Crop left eye
%                 secCrop = EyesBox;
%                 secCrop(3) = secCrop(3)/2;
%                 secCrop(1) = secCrop(1) + space+0.3*space;
%                 secCrop(3) = secCrop(3) - 0.5 *space;
%                 secCrop(2)=secCrop(2)+ 0.25*secCrop(4);
%                 secCrop(4) = secCrop(4) *0.4;
%                 videoLeftEye = imcrop(Face,secCrop);
%                 figure(11); subplot(2,1,1); imagesc(fliplr(videoRightEye)); subplot(2,1,2); imagesc(fliplr(videoLeftEye)); colormap gray
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
        z(find(x<0.2*size(x,1) | y<0.4*size(y,1)| x>0.8*size(x,1) | y>0.8*size(y,2)))=255;
        %find minimum of the curve
        [row,col]=find(z==min(min(z)));
        marker = true;

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
            mCol = round(aCol./wRatio);
            mRow = round(aRow./hRatio);
            try
                vRightEye(mRow(d),mCol(d))=255;
            catch
            end
        end
        axes(handles.axes2);
        cla(handles.axes2);
        %display image on axes 2
        imagesc(fliplr(vRightEye)); colormap gray
        yLinePos1 = round(13*height/20);
        yLinePos2 = round(9*height/20);
        xLinePos1 = round(13*width/20);
        xLinePos2 = round(11*width/20);
        %xLine needs to have a coeff such that XLine width coeff + XLine coeff = 1
        %if xLinePos = round(3*width/5), then mCol(d)>(2*xLinePos/3), 2*xLinePos/3 = 2*width/5
        %2*width/5 + 3*width/5 = width
        if ((width - mCol(d))>xLinePos1)&&(mRow(d)<yLinePos2)
            oneCounter = oneCounter + 1;
            twoCounter = 0;
            threeCounter = 0;
            fourCounter = 0;
            fiveCounter = 0;
            sixCounter = 0;
            sevenCounter = 0;
            eightCounter = 0;
            if oneCounter >= 4
                xP = [xLinePos1 (width+1) (width+1) xLinePos1];
                yP = [0 0 yLinePos2 yLinePos2];
                %patch(xP, yP, 'r');
                pos = [pos(1)+20,pos(2)-20];
                robot.mouseMove(pos(1),pos(2));
            end
        elseif ((width - mCol(d))<=xLinePos2)&&(mRow(d)<yLinePos2) 
            twoCounter = twoCounter + 1;
            oneCounter = 0;
            threeCounter = 0;
            fourCounter = 0;
            fiveCounter = 0;
            sixCounter = 0;
            sevenCounter = 0;
            eightCounter = 0;
            if twoCounter >= 4
                xP = [0 xLinePos2 xLinePos2 0];
                yP = [0 0 yLinePos2 yLinePos2];
                %patch(xP, yP, 'r');    
                pos = [pos(1)-20,pos(2)-20];
                robot.mouseMove(pos(1),pos(2));
            end
        elseif ((width-mCol(d))<=xLinePos2)&&(mRow(d)>=yLinePos1)
            threeCounter = threeCounter + 1;
            twoCounter = 0;
            oneCounter = 0;
            fourCounter = 0;
            fiveCounter = 0;
            sixCounter = 0;
            sevenCounter = 0;
            eightCounter = 0;
            if threeCounter >= 4
                xP = [0 xLinePos2 xLinePos2 0];
                yP = [yLinePos1 yLinePos1 (height+1) (height+1)];
                patch(xP, yP, 'r');
                pos = [pos(1)-20,pos(2)+20];
                robot.mouseMove(pos(1),pos(2));
            end
        elseif ((width-mCol(d))>xLinePos1)&&(mRow(d)>=yLinePos1)
            fourCounter = fourCounter + 1;
            twoCounter = 0;
            threeCounter = 0;
            oneCounter = 0;
            fiveCounter = 0;
            sixCounter = 0;
            sevenCounter = 0;
            eightCounter = 0;
            if fourCounter >= 4
                xP = [xLinePos1 (width+1) (width+1) xLinePos1];
                yP = [yLinePos1 yLinePos1 (height+1) (height+1)];
                %patch(xP, yP, 'r');
                pos = [pos(1)+20,pos(2)+20];
                robot.mouseMove(pos(1),pos(2));
            end
        elseif ((width-mCol(d))>xLinePos1)&&(mRow(d)>=yLinePos2)&&(mRow(d)<yLinePos1)
            fiveCounter = fiveCounter + 1;
            eightCounter=0;
            fourCounter = 0;
            sevenCounter = 0;
            sixCounter = 0;
            twoCounter = 0;
            threeCounter = 0;
            oneCounter = 0;
            if fiveCounter >= 4
                xP = [xLinePos1 (width+1) (width+1) xLinePos1];
                yP = [yLinePos2 yLinePos2 yLinePos1 yLinePos1];
                %patch(xP, yP, 'r');
                pos = [pos(1)+20,pos(2)];
                robot.mouseMove(pos(1),pos(2));
            end
        elseif ((width-mCol(d))<=xLinePos1)&&((width-mCol(d))>xLinePos2)&&(mRow(d)<yLinePos2)
            sixCounter = sixCounter + 1;
            twoCounter = 0;
            threeCounter = 0;
            fourCounter = 0;
            fiveCounter = 0;
            oneCounter = 0;
            sevenCounter = 0;
            eightCounter = 0;
            if sixCounter >= 4
                xP = [xLinePos2 xLinePos1 xLinePos1 xLinePos2];
                yP = [0 0 yLinePos2 yLinePos2];
                %patch(xP, yP, 'r');       
                pos = [pos(1),pos(2)-20];
                robot.mouseMove(pos(1),pos(2));
            end
        elseif ((width-mCol(d))<=xLinePos2)&&(mRow(d)>=yLinePos2)&&(mRow(d)<yLinePos1)
            sevenCounter = sevenCounter + 1;
            eightCounter=0;
            fourCounter = 0;
            fiveCounter = 0;
            sixCounter = 0;
            twoCounter = 0;
            threeCounter = 0;
            oneCounter = 0;
            if sevenCounter >= 4
                xP = [0 xLinePos2 xLinePos2 0];
                yP = [yLinePos2 yLinePos2 yLinePos1 yLinePos1];
                %patch(xP, yP, 'r');
                pos = [pos(1)-20,pos(2)];
                robot.mouseMove(pos(1),pos(2));
            end
        elseif ((width-mCol(d))<=xLinePos1)&&((width-mCol(d))>xLinePos2)&&(mRow(d)>=yLinePos1)
            eightCounter = eightCounter + 1;
            twoCounter = 0;
            threeCounter = 0;
            fourCounter = 0;
            fiveCounter = 0;
            sixCounter = 0;
            sevenCounter = 0;
            oneCounter = 0;
            if eightCounter >= 4
                xP = [xLinePos2 xLinePos1 xLinePos1 xLinePos2];
                yP = [yLinePos1 yLinePos1 (height+1) (height+1)];
                %patch(xP, yP, 'r'); 
                pos = [pos(1),pos(2)+20];
                robot.mouseMove(pos(1),pos(2));
            end
        else
             xP = [xLinePos2 xLinePos1 xLinePos1 xLinePos2];
             yP = [yLinePos2 yLinePos2 yLinePos1 yLinePos1];
             %patch(xP, yP, 'r'); 

        end


        xL1 = get(gca,'XLim');
        line(xL1,[round(5*height/20) round(5*height/20)],'Color','r');
        line(xL1,[round(7*height/20) round(7*height/20)],'Color','r');
        line(xL1,[round(9*height/20) round(9*height/20)],'Color','r');
        line(xL1,[round(11*height/20) round(11*height/20)],'Color','r');
        line(xL1,[round(13*height/20) round(13*height/20)],'Color','r');
        line(xL1,[round(15*height/20) round(15*height/20)],'Color','r');
        yL = get(gca,'YLim');
        line([round(5*width/20) round(5*width/20)],yL,'Color','r');
        line([round(7*width/20) round(7*width/20)],yL,'Color','r');
        line([round(9*width/20) round(9*width/20)],yL,'Color','r');
        line([round(11*width/20) round(11*width/20)],yL,'Color','r');
        line([round(13*width/20) round(13*width/20)],yL,'Color','r');
        line([round(15*width/20) round(15*width/20)],yL,'Color','r');
        line([round(17*width/20) round(17*width/20)],yL,'Color','r');
        %Sample Grid
        grid on;
        handles.axes2.GridColor = 'w';
        handles = guidata(hObject);
               
        %Once enough markers are found, output average position
        %data with mins and max.
        j = j + 1;
        if  j==60
            handles.gather = false;
            j = 0;
            averageCol = mean(aCol)  %Column for X coordinate
            maxCol = max(aCol)
            minCol = min(aCol)
            averageRow = mean(aRow) %Row for Y coordinate
            maxRow = max(aRow)
            minRow = min(aRow)
            hObject.String = 'Start';
            handles.loop = false;
            guidata(hObject, handles);
        end


        a=toc;
        set(handles.text5, 'String', num2str(1/a));
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
 
 
% --- Executes on button press in pushbutton5.
%function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%handles.gather = true; 
%guidata(hObject, handles); %Get the newest GUI data   
%end
