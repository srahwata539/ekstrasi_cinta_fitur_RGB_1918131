function varargout = lukas(varargin)
% LUKAS MATLAB code for lukas.fig
%      LUKAS, by itself, creates a new LUKAS or raises the existing
%      singleton*.
%
%      H = LUKAS returns the handle to a new LUKAS or the handle to
%      the existing singleton*.
%
%      LUKAS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LUKAS.M with the given input arguments.
%
%      LUKAS('Property','Value',...) creates a new LUKAS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before lukas_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to lukas_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help lukas

% Last Modified by GUIDE v2.5 27-May-2022 18:50:52

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @lukas_OpeningFcn, ...
                   'gui_OutputFcn',  @lukas_OutputFcn, ...
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


% --- Executes just before lukas is made visible.
function lukas_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to lukas (see VARARGIN)

% Choose default command line output for lukas
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes lukas wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = lukas_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[nama_file,nama_folder]=uigetfile(...
    {'*.bmp; *.jpeg; *.png; *.jpg; *.jfif', 'File citra (*.bmp, *.jpg, *.png)';
    '*.bmp' , 'File Bitmap(*.bmp)';
    '*.png' , 'File Png(*.png)';
    '*.jpg' , 'File Jpeg (*.jpg)';
    '*.*', 'Semua File (*.*)'},...
    'Buka Citra asli');

%jika ada nama file yang terpilih maka akan mengeksekusi percabanan ini
if ~isequal(nama_file,0)
    %membaca ctra rgb
    citra=imread(fullfile(nama_folder,nama_file));
    %menampikan citra di axes
    axes(handles.axes1)
    imshow(citra)
    title('citra yang di olah')
    %simpan variabel i d dalam handles agar bisa di simpan
    handles.citra=citra;
    guidata(hObject,handles)
else
    %jika tidak ada file maka akan kembali
    return    
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.current_data1=handles.citra;
rgb=handles.current_data1;
out = uint8(zeros(size(rgb,1), size(rgb,2), size(rgb,3)));
 
%R,G,B components of the input image
R = rgb(:,:,1);
G = rgb(:,:,2);
B = rgb(:,:,3);
 
%Inverse of the Avg values of the R,G,B
mR = 1/(mean(mean(R)));
mG = 1/(mean(mean(G)));
mB = 1/(mean(mean(B)));
 
%Smallest Avg Value (MAX because we are dealing with the inverses)
maxRGB = max(max(mR, mG), mB);
 
%Calculate the scaling factors
mR = mR/maxRGB;
mG = mG/maxRGB;
mB = mB/maxRGB;
 
%Scale the values
out(:,:,1) = R*mR;
out(:,:,2) = G*mG;
out(:,:,3) = B*mB;
 
%Convert the image from RGB to YCbCr
img_ycbcr = rgb2ycbcr(out);
Cb = img_ycbcr(:,:,2);
Cr = img_ycbcr(:,:,3);
 
%Detect Skin
[r,c,v] = find(Cb>=77 & Cb<=127 & Cr>=133 & Cr<=173);
numind = size(r,1);
 
bin = false(size(rgb,1), size(rgb,2));
%Mark Skin Pixels
for i=1:numind
    bin(r(i),c(i)) = 1;
end
 
bin = imfill(bin,'holes');
R(~bin) = 0;
G(~bin) = 0;
B(~bin) = 0;
out = cat(3,R,G,B);
    
    

red=mean(mean(rgb(:,:,1)));
green=mean(mean(rgb(:,:,2)));
blue=mean(mean(rgb(:,:,3)));

set(handles.edit1,'string',red);
set(handles.edit2,'string',green);
set(handles.edit3,'string',blue);




function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
