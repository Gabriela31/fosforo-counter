function varargout = video101(varargin)
% VIDEO101 MATLAB code for video101.fig
%      VIDEO101, by itself, creates a new VIDEO101 or raises the existing
%      singleton*.
%
%      H = VIDEO101 returns the handle to a new VIDEO101 or the handle to
%      the existing singleton*.
%
%      VIDEO101('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VIDEO101.M with the given input arguments.
%
%      VIDEO101('Property','Value',...) creates a new VIDEO101 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before video101_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to video101_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help video101

% Last Modified by GUIDE v2.5 16-Jun-2021 13:29:08

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @video101_OpeningFcn, ...
                   'gui_OutputFcn',  @video101_OutputFcn, ...
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


% --- Executes just before video101 is made visible.
function video101_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to video101 (see VARARGIN)

% Choose default command line output for video101
handles.output = hObject;

% inicializar la camara
closepreview();
handles.video=videoinput('winvideo', 2);
axes(handles.video_axes);
HI = image(zeros(360,640,3),'Parent',handles.video_axes);
preview(handles.video,HI);
% set axes de captura
axes(handles.capture_axes);
axis off;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes video101 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = video101_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in btn_capture.
function btn_capture_Callback(hObject, eventdata, handles)
% hObject    handle to btn_capture (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.my_img = getsnapshot(handles.video); %función de captura de una imagen
% handles_my_img_axes = handles.my_img;

% mostrar la imagen en el axes
% set(handles.capture_axes,'Units','pixels');
% resizePos = get(handles.capture_axes,'Position');
% handles_my_img_axes = imresize(handles_my_img_axes, [resizePos(3) resizePos(3)]);
% axes(handles.capture_axes);
% imshow(handles_my_img_axes);
% set(handles.capture_axes,'Units','normalized');

axes(handles.capture_axes);
imshow(uint8(handles.my_img));
img_name = "img_" + datestr(now,'yyyy-mm-dd_hh-MM-ss.jpg');
imwrite(handles.my_img,char(img_name));

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in btn_progreso.
function btn_progreso_Callback(hObject, eventdata, handles)
% hObject    handle to btn_progreso (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

figure(1)
subplot(2,2,1);
imshow(uint8(handles.Z));
title('Binarización para detección de forma con fondo morado: H < 140');
ax = gca;
ax.FontSize = 8;

subplot(2,2,2);
imshow(uint8(handles.mask_red));
title('Binarización para detección de cabeza roja: H < 15');
ax = gca;
ax.FontSize = 8;

subplot(2,2,3);
imshow(uint8(handles.mask_black));
title('Binarización para detección de cabeza negra: S < 122, 35 < V < 70 y H < 165');
ax = gca;
ax.FontSize = 8;

subplot(2,2,4);
imshow(uint8(handles.my_img));
title('Imagen original');
ax = gca;
ax.FontSize = 8;

impixelinfo;

figure(2)
subplot(2,2,1);
imshow(uint8(handles.my_img));
title('Captura original')
subplot(2,2,2);
imshow(uint8(handles.H));
title('Matriz H')
subplot(2,2,3);
imshow(uint8(handles.S));
title('Matriz S')
subplot(2,2,4);
imshow(uint8(handles.V));
title('Matriz V')
impixelinfo;

% --- Executes on button press in btn_upload.
function btn_upload_Callback(hObject, eventdata, handles)
% hObject    handle to btn_upload (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% cargar la imagen
[my_filename, my_folder] = uigetfile('*.jpg');
my_file = my_folder + "" + my_filename; 
handles.my_img = imread(my_file);
handles_my_img_axes = handles.my_img;

% mostrar la imagen en el axes
set(handles.capture_axes,'Units','pixels');
resizePos = get(handles.capture_axes,'Position');
handles_my_img_axes = imresize(handles_my_img_axes, [resizePos(3) resizePos(3)]);
axes(handles.capture_axes);
imshow(handles_my_img_axes);
set(handles.capture_axes,'Units','normalized');

% actualizar variables
guidata(hObject,handles);


% --- Executes on button press in btn_procesar.
function btn_procesar_Callback(hObject, eventdata, handles)
% hObject    handle to btn_procesar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% procesamiento de tamano
% handles.my_img = imresize(handles.my_img, 0.5); % 640x640
[M,N,P] = size(handles.my_img);

% convertir a hsv para detectar fondo azul
[handles.HSV]=rgb2hsv(handles.my_img);

handles.H=handles.HSV(:,:,1);
handles.S=handles.HSV(:,:,2);
handles.V=handles.HSV(:,:,3);

handles.H=round(255*handles.H);
handles.S=round(255*handles.S);
handles.V=round(255*handles.V);

% segun color
num_colorA = 0;
num_colorB = 0;
num_no_polvora = 0;
% palitos de contacto
num_contacto_completo = 0;
num_contacto_partido = 0;
num_contacto_mixto = 0;
% palitos montados
num_montado_completo = 0;
num_montado_partido = 0;
num_montado_mixto = 0;
% forma
num_completo = 0;
num_partido = 0;
% total
num_total = 0;

handles.Z = zeros(M,N);
current_object = find(handles.H<140); % fondo morado
handles.Z(current_object) = 255;

% deteccion rojos
handles.mask_red = zeros(M,N);
current_object_red = find(handles.H<15); % fondo rojo
handles.mask_red(current_object_red) = 255;
[etiquetas_rojo, num_objetos_rojo] = bwlabel(handles.mask_red,8);

for i=1:num_objetos_rojo
    current_object = find(etiquetas_rojo==i);
    len_current = length(current_object);
    if len_current >= 150
        if len_current >= 150*1.7
            num_colorA = num_colorA + 2;
        else
            num_colorA = num_colorA + 1;
        end
    end
end

% deteccion negros
handles.mask_black = zeros(M,N);
current_object_black = find(handles.S>0 & handles.V>35 & handles.H<165 & handles.S<122 & handles.V<70);
handles.mask_black(current_object_black) = 255;
[etiquetas_black, num_objetos_black] = bwlabel(handles.mask_black,8);

for i=1:num_objetos_black
    current_object = find(etiquetas_black==i);
    len_current = length(current_object);
    
    if len_current >= 35
        if len_current / (0.25*1800) >1.2
            num_colorB = num_colorB + 2;
        else
            num_colorB = num_colorB + 1;
        end
    end
end

% deteccion de objetos
[etiquetas, num_objetos] = bwlabel(handles.Z,8);

% para detectar 000111111
comparador = ones(1, 20) * 255;
comparador(1:6) = [0 0 0 0 0 0];

% numero de pixeles de un fosforo
len_fosforo = 1880;

for i=1:num_objetos
    
    es_montado = false;
    current_object = find(etiquetas==i);
    len_current = length(current_object);
    
    % si no es ruido analizar
    if len_current > 36
                
        % si es partido o no
        if len_current <= len_fosforo*0.7
            num_partido = num_partido + 1;
        else
            if len_current > len_fosforo*1.4
                % si es completo
                if len_current > len_fosforo*2.1

                    % evaluacion si es partido
                    F = zeros(M,N);
                    F(current_object) = 255;
                    for i = 1:M
                        fila_actual = F(i,:);
                        indices = strfind(fila_actual,comparador);
                        if(length(indices) > 1)
                            es_montado = true;
                            break;
                        end
                    end
                    
                    if es_montado == true
                        num_montado_completo = num_montado_completo + 1;
                        num_completo = num_completo + 2;
                    else
                        num_contacto_completo = num_contacto_completo + 1;
                        num_completo = num_completo + 2;
                    end
                    
                % si es mixto
                else
                    % evaluacion si es partido
                    F=zeros(M,N);
                    F(current_object)=255;
                    for i = 1:M
                        fila_actual = F(i,:);
                        indices = strfind(fila_actual,comparador);
                        if(length(indices) > 1)
                            es_montado = true;
                            break;
                        end
                    end
                    
                    if es_montado == true
                        num_montado_mixto = num_montado_mixto + 1;
                        num_completo = num_completo + 1;
                        num_partido = num_partido + 1;
                    else
                        num_contacto_mixto = num_contacto_mixto + 1;
                        num_partido = num_partido + 1;
                        num_completo = num_completo + 1;
                    end
                    
                end
            
            % evaluacion si es partido
            else
                
                F=zeros(M,N);
                F(current_object)=255;
                for i = 1:M
                    fila_actual = F(i,:);
                    indices = strfind(fila_actual,comparador);
                    if(length(indices) > 1)
                        es_montado = true;
                        break;
                    end
                end
                
                if es_montado == true
                    num_montado_partido = num_montado_partido + 1;
                    num_partido = num_partido + 2;
                
                else
                    F = zeros(M,N);
                    F(current_object)=255;
                    [x,y]=find(F==255);
                    
                    if max((max(x)-min(x)),(max(y)-min(y))) < 150
                        num_contacto_partido = num_contacto_partido + 1;
                        num_partido = num_partido + 2;
                    else
                        num_completo = num_completo + 1;
                    end
                end
               
            end
        end
    end
end

num_total = num_partido + num_completo;
num_no_polvora = num_total - num_colorA - num_colorB;

%cambiar los labels color
set(handles.lbl_sin_cabeza,'String', sprintf("Sin cabeza: %d",num_no_polvora));
set(handles.lbl_color_rojo,'String', sprintf("Rojo: %d",num_colorA));
set(handles.lbl_color_negro,'String', sprintf("Negro: %d",num_colorB));
% cambiar los labels montado
set(handles.lbl_montado_completo,'String', sprintf("1C + 1C: %d",num_montado_completo));
set(handles.lbl_montado_mixto,'String', sprintf("1C + 1P: %d",num_montado_mixto));
set(handles.lbl_montado_partido,'String', sprintf("1P + 1P: %d",num_montado_partido));
% cambiar los labels contacto
set(handles.lbl_contacto_completo,'String', sprintf("1C + 1C: %d",num_contacto_completo));
set(handles.lbl_contacto_mixto,'String', sprintf("1C + 1P: %d",num_contacto_mixto));
set(handles.lbl_contacto_partido,'String', sprintf("1P + 1P: %d",num_contacto_partido));
% cambiar los labels forma
set(handles.lbl_completo,'String', sprintf("Completos: %d", num_completo));
set(handles.lbl_partido,'String', sprintf("Partidos: %d", num_partido));
set(handles.lbl_total,'String', sprintf("Total: %d", num_total));

% actualizar variables
guidata(hObject,handles);
