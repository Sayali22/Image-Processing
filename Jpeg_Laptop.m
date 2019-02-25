function varargout = Jpeg_Laptop(varargin)
% JPEG_LAPTOP MATLAB code for Jpeg_Laptop.fig
% This program Gives the Compressed output of given image using JPEG Lossy
% compression Technique.
% 
%  JPEG_LAPTOP, by itself, creates a new JPEG_LAPTOP or raises the existing
%  singleton*.
%
%  H = JPEG_LAPTOP returns the handle to a new JPEG_LAPTOP or the handle to
%      the existing singleton*.
%
%   JPEG_LAPTOP('CALLBACK',hObject,eventData,handles,...) calls the local
%   function named CALLBACK in JPEG_LAPTOP.M with the given input arguments.
%
%   JPEG_LAPTOP('Property','Value',...) creates a new JPEG_LAPTOP or raises 
%   existing singleton*.  Starting from the left, property value pairs are
%   applied to the GUI before Jpeg_Laptop_OpeningFcn gets called.  An
%   unrecognized property name or invalid value makes property application
%   stop.  All inputs are passed to Jpeg_Laptop_OpeningFcn via varargin.
%
%   *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Jpeg_Laptop

% Last Modified by GUIDE v2.5 13-Oct-2018 15:22:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Jpeg_Laptop_OpeningFcn, ...
                   'gui_OutputFcn',  @Jpeg_Laptop_OutputFcn, ...
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


% --- Executes just before Jpeg_Laptop is made visible.
function Jpeg_Laptop_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Jpeg_Laptop (see VARARGIN)


% Choose default command line output for Jpeg_Laptop
handles.output = hObject;

% Choose default command line output for myslider
set(handles.slider_k, 'Value', 1);                    %Initilaizing K=1
handles.slider_k = get(handles.slider_k,'Value');

% Update handles structure
guidata(hObject, handles);


% UIWAIT makes Jpeg_Laptop wait for user response (see UIRESUME)
% uiwait(handles.figure1);




% --- Outputs from this function are returned to the command line.
function varargout = Jpeg_Laptop_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function slider_k_Callback(hObject, eventdata, handles)
% hObject    handle to slider_k (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
  
  slider_value = get(hObject, 'Value' ); % save the current slider value
  handles.slider_k = slider_value;       % make its scope global
  
  
  set(handles.edit_slider,'string',num2str(slider_value));% display in text
  guidata(hObject,handles)
  
% Hints: get(hObject,'Value') returns position of slider
%   get(hObject,'Min') and get(hObject,'Max') to determine range of slider



% --- Executes on button press in compress_pushbtn.
function compress_pushbtn_Callback(hObject, eventdata, handles)
% hObject    handle to compress_pushbtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

 origin = handles.image;                   %open Selected image
 slider_k = handles.slider_k ;             %Save slider value
 
if size(origin,3)==3 % Process data if its color image
  
  out_block = @(out) jpegmain(out.data , slider_k);
  % calls jpegmain function for every  8*8
  r = blockproc(origin(: , : , 1) ,[8 8], out_block); 
  g = blockproc(origin(: , : , 2) ,[8 8], out_block);
  b = blockproc(origin(: , : , 3) ,[8 8], out_block);
  output = cat(3, r , g , b);
  axes(handles.axes_compress);
  imshow (output); 

  
else % Process data if its grayscale image
    
  out_block = @(out) jpegmain(out.data , slider_k);
   % calls jpegmain function for every  8*8
  output = blockproc(origin ,[8,8], out_block);
  axes(handles.axes_compress);
  imshow (output);
  

end

handles.output = output;  %make the output value scope gobal
guidata(hObject,handles)

 function dctfun = jpegmain(out_blk, k) 
 
 quant = [16  11  10  16  24  40  51  61; %Predefined Qunatization value
         12  12  14  19  26  58  60  55;
         14  13  16  24  40  57  69  56;
         14  17  22  29  51  87  80  62;
         18  22  37  56  68  109 103 77;
         24  35  55  64  81  104 113 92;
         49  64  78  87  103 121 120 101;
         72  92  95  98  112 100 103 99 ];
     
%DCT/IDCT lossy compression
 dctfun = uint8(idct2((round((dct2(out_blk))./(k.*quant))) .*(k.*quant))); 
 


% --- Executes on selection change in select_PopupMenu.
function select_PopupMenu_Callback(hObject, eventdata, handles)
% hObject    handle to select_PopupMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% Hints: contents = cellstr(get(hObject,'String')) returns select_PopupMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from select_PopupMenu

% Determine the selected data set.
str = get(hObject, 'String');
val = get(hObject,'Value');

% Set current data to the selected data set.
switch str{val}
            
case 'Brightness' % User selects Brightness.
   img1 = handles.image; 
   val = 15 * get(hObject,'Value') - 0.5 ; %get the current pixels then +and* by predifined values
   img2 = img1 + val;
   axes(handles.axes_origin);  
   imshow(img2);
   handles.image = img2;
   
case 'Darkness' % User selects Canny Image.   
   img1 = handles.image; 
   val = 15/get(hObject,'Value') -50 ; %get the current pixels then /and- predifined values
   img2 = img1 + val;
   axes(handles.axes_origin);  
   imshow(img2);
   handles.image = img2;
 
 case 'Discarded Pixels'
   original = handles.image; 
   compress = handles.output;
   error = original- compress;  % Diffrence will show the removed pixels 
   axes(handles.axes_origin);  
   imshow(error);
   handles.image = error;
   
end
% Save the handles structure.
guidata(hObject,handles)



% --- Executes during object creation, after setting all properties.
function select_PopupMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to select_PopupMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in origin_pushbtn.
function origin_pushbtn_Callback(hObject, eventdata, handles)
% hObject    handle to origin_pushbtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[FileName , PathName] = uigetfile('*.jpg;*.tif;*.png;*.bmp','FileSelector');
image = strcat( PathName ,FileName);  % Browse
axes(handles.axes_origin);            % Display it on 1st axes
imshow(image);

handles.image = imread(image);        % making its scope global 
guidata(hObject,handles)              % saves the handles structure


function edit_slider_Callback(hObject, eventdata, handles)
% hObject    handle to edit_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

edit = get(hObject, 'string');                     %Takes the value of text
set(handles.slider_value,'string',str2num(edit));  %Displays the value of K
guidata(hObject,handles)

% Hints: get(hObject,'String') returns contents of edit_slider as text
%        str2double(get(hObject,'String')) returns contents of edit_slider as a double


% --- Executes during object creation, after setting all properties.
function edit_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
