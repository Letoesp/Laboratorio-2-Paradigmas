%Laboratorio 2 Prolog
%Nombre: Leonardo Espinoza
%Profesor: Miguel Truffa
:-include(tdapixel_20424317_Espinoza).
%%%%%%%%%%%TDA IMAGE%%%%%%%%%%%%%
%Dominio:
%image:imagen proporcionada por pixeles
%pixel:pixel creado
%pixrgb:pixel rgb
%string:string
%list: lista
%TDA Image
%
%
%Predicados:
%Width (int) X Height (int) X [pixbit* |  pixrgb* | pixhex*] X image
%
%
%imageisbitmap()
%imageispixmap()
%imageishexmap()
%imageIsCompressed()
%imageFlipH()
%imageFlipV()
%imageCrop()
%imageRGBToHex()
%imageToHistogram()
%imageCompress()
%imageChangePixel()
%imageInvertColorRGB()
%imageToString()
%imageDepthLayers()
%imageDecompress()
%Metas Primarias:
%Construir imagen a traves de pixeles
%Metas Secundarias:
%
%girar imagen de forma vertical
%girar imagen de forma horizontal
%recortar imagen
%retornar un histograma
%rotar imagen
%comprimir imagen
%reemplazar pixel en una imagen
%transformar imagen a string
%separar imagen en capas
%descomprimir imagen
%%%%%%%%%Representaci�n%%%%%%%%%%%%%%%%
% EL TDA IMAGE representa una imagen y está estructurada en listas
%
% %%%%%%%%%%%Constructor y Pertenencia:%%%%%%%%%%%%%%%%%
%Clausulas Hechos
%
%Dominio: Se pide un tamaño de imagen (ancho y largo) y una cantidad de pixeles de forma homogénea
% Descripción : predicado que construye imagenes con bitmaps, hexmaps o
% pixmaps. Se incluye informacion de profundidad de cada pixel
image(Ancho, Largo, Pixeles, [Ancho, Largo, Pixeles]).

%
%Dominio: image
% Descripcion: predicado que permite determinar si la imagen corresponde
% a un bitmap-d
% se utiliza un predicado auxiliar que permite comprobar si la lista
% ingresada son pixbits.
ispixbit([]).
ispixbit([Pixbit | Rest]) :-
  pixbit(_, _, Valor, _, Pixbit),
  (Valor == 0 ; Valor == 1),
  ispixbit(Rest).

imageIsBitmap(Image):-
    image(_,_,Pixeles,Image),
    ispixbit(Pixeles).

%Dominio: image
% Descripcion: predicado que permite determinar si la imagen corresponde
% a un pixmap-d
% se utiliza un predicado auxiliar que permite identificar si la imagen
% posee pixrgbs
ispixrgb([]).
ispixrgb([Pixrgb|Rest]):-
    pixrgb(_,_,R,G,B,_,Pixrgb),
    (   R>=0,R=<255),
    (   G>=0, G=<255),
    (   B>=0, B=<255),
    ispixrgb(Rest).

imageIsPixmap(Image):-
    image(_,_,Pixeles,Image),
    ispixrgb(Pixeles).

%
%Dominio: image
% Descripcion: predicado que permite determinar si la imagen corresponde
% a un hexmap-d se utiliza un predicado auxiliar que permite saber si la
% imagen posee pixhexs
%
ispixhex([]).
ispixhex([Pixhex | Rest]) :-
    pixhex(_, _, Hex, _, Pixhex),
    string(Hex),
    ispixhex(Rest).

imageIsHexmap(Image):-
    image(_,_,Pixeles,Image),
    ispixhex(Pixeles).

%Dominio: image
%Descripcion: predicado que determina si una imagen esta comprimida.
% se utiliza un predicado auxiliar que determina la cantidad de pixeles
% de una imagen.
cantpixs([],0).
cantpixs([_|Rest],Contador):-
    cantpixs(Rest,Acum),
    Contador is Acum + 1.



imageIsCompressed(Image):-
    image(Ancho,Largo,Pixeles,Image),
    Dimensiones is Ancho*Largo,
    cantpixs(Pixeles,Cantidad),
    Cantidad<Dimensiones.
% %%%%%%%%%%%Selectores%%%%%%%%%%%%%%
%
%
%
%%%%%%%%%%%Otros Predicados%%%%%%%%%%%%%%%%%
%
%Dominio: image
%Descripción: predicado que permite invertir una imagen horizontalmente
% se utilizan para cada caso predicados auxiliares que permite hacer el
% movimiento segun el tiempo de imagen, y el predicado imageflipH
% permite unificar.
movepixbitsH(_,[],_).
movepixbitsH(Ancho,[Pixel|Rest],[PixelR|PixelesR]):-
    pixbit(X,Y,Valor,Prof,Pixel),
    NewY is Ancho-(Y+1),
    pixbit(X,NewY,Valor,Prof,PixelR),
    movepixbitsH(Ancho,Rest,PixelesR).

movepixrgbsH(_,[],_).
movepixrgbsH(Ancho,[Pixel|Rest],[PixelR|PixelesR]):-
    pixrgb(X,Y,R,G,B,Prof,Pixel),
    NewY is Ancho-(Y+1),
    pixrgb(X,NewY,R,G,B,Prof,PixelR),
    movepixrgbsH(Ancho,Rest,PixelesR).

movepixhexsH(_,[],_).
movepixhexsH(Ancho,[Pixel|Rest],[PixelR|PixelesR]):-
    pixhex(X,Y,Hex,Prof,Pixel),
    NewY is Ancho-(Y+1),
    pixhex(X,NewY,Hex,Prof,PixelR),
    movepixhexsH(Ancho,Rest,PixelesR).


imageFlipH(Image,ImageR):-
    image(Ancho,Largo,Pixeles,Image),
    (imageIsBitmap(Image))->
    movepixbitsH(Ancho,Pixeles,PixelesR),
    image(Ancho,Largo,PixelesR,ImageR);

    (imageIsPixmap(Image))->
    image(Ancho,Largo,Pixeles,Image),
    movepixrgbsH(Ancho,Pixeles,PixelesR),
    image(Ancho,Largo,PixelesR,ImageR);

    (imageIsHexmap(Image))->
    image(Ancho,Largo,Pixeles,Image),
    movepixhexsH(Ancho,Pixeles,PixelesR),
    image(Ancho,Largo,PixelesR,ImageR).

%Dominio: image
%Descripcion: predicado que permite invertir una imagen verticalmente
% se utilizan predicados auxiliares segun el caso que permite segun el
% timpo de imagen hacer el flip. el imageflip unifica.
%
movepixbitsV(_,[],_).
movepixbitsV(Largo,[Pixel|Rest],[PixelR|PixelesR]):-
    pixbit(X,Y,Valor,Prof,Pixel),
    NewX is Largo-(X+1),
    pixbit(NewX,Y,Valor,Prof,PixelR),
    movepixbitsV(Largo,Rest,PixelesR).

movepixrgbsV(_,[],_).
movepixrgbsV(Largo,[Pixel|Rest],[PixelR|PixelesR]):-
    pixrgb(X,Y,R,G,B,Prof,Pixel),
    NewX is Largo-(X+1),
    pixrgb(NewX,Y,R,G,B,Prof,PixelR),
    movepixrgbsV(Largo,Rest,PixelesR).

movepixhexsV(_,[],_).
movepixhexsV(Largo,[Pixel|Rest],[PixelR|PixelesR]):-
    pixhex(X,Y,Hex,Prof,Pixel),
    NewX is Largo-(X+1),
    pixhex(NewX,Y,Hex,Prof,PixelR),
    movepixhexsV(Largo,Rest,PixelesR).

imageFlipV(Image,ImageR):-
    image(Ancho,Largo,Pixeles,Image),
    (imageIsBitmap(Image))->
    movepixbitsV(Largo,Pixeles,PixelesR),
    image(Ancho,Largo,PixelesR,ImageR);

    (imageIsPixmap(Image))->
    image(Ancho,Largo,Pixeles,Image),
    movepixrgbsV(Largo,Pixeles,PixelesR),
    image(Ancho,Largo,PixelesR,ImageR);

    (imageIsHexmap(Image))->
    image(Ancho,Largo,Pixeles,Image),
    movepixhexsV(Largo,Pixeles,PixelesR),
    image(Ancho,Largo,PixelesR,ImageR).

%Dominio: image X x1 (int) X y1 (int) X x2 (int) X y2 (int)
%
% Descripcion: predicado que permite cortar una imagen a partir de un
% cuadrante.
% se usan predicados auxiliares segun el tipo de imagen que permite
% cortar la imagen
% como dato: al cortar la imagen, se logra cortar la imagen pero los
% espacios de memorias quedan ah� vac�os.
%
cropBitmap([],_,_,_,_,_).
cropBitmap([Pixel|Rest],X1,Y1,X2,Y2,[PixelR|PixelesR]):-
    pixbit(X,Y,Valor,Prof,Pixel),
    ((X>=X1,Y>=Y1)->
    (X=<X2,Y=<Y2)->
    pixbit(X,Y,Valor,Prof,PixelR),
    cropBitmap(Rest,X1,Y1,X2,Y2,PixelesR));

    cropBitmap(Rest,X1,Y1,X2,Y2,PixelesR).



cropPixmap([],_,_,_,_,_).
cropPixmap([Pixel|Rest],X1,Y1,X2,Y2,[PixelR|PixelesR]):-
    pixrgb(X,Y,R,G,B,Prof,Pixel),
    ((X>=X1,Y>=Y1)->
    (X=<X2,Y=<Y2)->
    pixrgb(X,Y,R,G,B,Prof,PixelR),
    cropPixmap(Rest,X1,Y1,X2,Y2,PixelesR));
    cropPixmap(Rest,X1,Y1,X2,Y2,PixelesR).


cropHexmap([],_,_,_,_,_).
cropHexmap([Pixel|Rest],X1,Y1,X2,Y2,[PixelR|PixelesR]):-
    pixhex(X,Y,Hex,Prof,Pixel),
    ((X>=X1,Y>=Y1)->
    (X=<X2,Y=<Y2)->
    pixhex(X,Y,Hex,Prof,PixelR),
    cropHexmap(Rest,X1,Y1,X2,Y2,PixelesR));
    cropHexmap(Rest,X1,Y1,X2,Y2,PixelesR).

imageCrop(Image,X1,Y1,X2,Y2,ImageR):-
    image(_,_,Pixeles,Image),
    (imageIsBitmap(Image))->
    cropBitmap(Pixeles,X1,Y1,X2,Y2,PixelesR),
    NewAncho is X2-X1+1,
    NewLargo is Y2-Y1+1,
    image(NewAncho,NewLargo,PixelesR,ImageR);

    (imageIsPixmap(Image))->
    image(_,_,Pixeles,Image),
    cropPixmap(Pixeles,X1,Y1,X2,Y2,PixelesR),
    NewAncho is X2-X1+1,
    NewLargo is Y2-Y1+1,
    image(NewAncho,NewLargo,PixelesR,ImageR);

    (imageIsHexmap(Image))->
    image(_,_,Pixeles,Image),
    cropHexmap(Pixeles,X1,Y1,X2,Y2,PixelesR),
    NewAncho is X2-X1+1,
    NewLargo is Y2-Y1+1,
    image(NewAncho,NewLargo,PixelesR,ImageR).

%Dominio: image
% Descripción: funcion que transforma una imagen desde una
% representacion RGB a una representacion HEX.
% se utilizan predicados auxiliares, uno que permite transformar un
% numero a hexadecimal, y el otro divide el numero en 16 para realizar
% la conversi�n a hexadecimal.
%
numtoHex(Numero,String):-
    (Numero=<9)->
    number_string(Numero,String);
    (Numero==10)->
    atom_string('A',String);
    (Numero==11)->
    atom_string('B',String);
    (Numero==12)->
    atom_string('C',String);
    (Numero==13)->
    atom_string('D',String);
    (Numero==14)->
    atom_string('E',String);
    (Numero==15)->
    atom_string('F',String).


dividir(Numero,StringR):-
    (Numero<16)->
    numtoHex(Numero,String),
    string_concat('0',String,StringR);
    Cuociente is Numero//16,
    numtoHex(Cuociente,String1),
    Resto is Numero rem 16,
    numtoHex(Resto,String2),
    string_concat(String1,String2,StringR).


pixstohex([],_).
pixstohex([Pixel|Rest],[PixelR|PixelesR]):-
    pixrgb(X,Y,R,G,B,Prof,Pixel),
    dividir(R,NewR),
    dividir(G,NewG),
    dividir(B,NewB),
    string_concat(NewR,NewG,Hex),
    string_concat(Hex,NewB,NewHex),
    pixhex(X,Y,NewHex,Prof,PixelR),
    pixstohex(Rest,PixelesR).


imageRGBToHex(Image,ImageR):-
    image(Ancho,Largo,Pixeles,Image),
    pixstohex(Pixeles,PixelesR),
    image(Ancho,Largo,PixelesR,ImageR).

%Dominio: image
%Descripción: función que rota la imagen 90 grados a la derecha

%Dominio: image
%Descripción: función que comprime una imagen eliminando aquellos pixeles con el color
%más frecuente
%
%Dominio: pixbit-d
%Descripción: función que permite obtener el valor del bit opuesto
%
%Dominio: pixrgb-d
%Descripción: función que permite obtener el color simetricamente opuesto en cada
%canal dentro de un pixel
%
%Dominio: f1 X F2 x F3 x pixrgb-d
%Descripción: función que permite ajustar cualquier canal de una imagen con pixeles
%pixrgb-d, incluido el canal de profundidad d.
%
%Dominio:image X f
%Descripción: función que transforma una imagen a una representación string.
%
%Dominio: image
%Descripción: función que permite separar una imagen en capas en base a la profundidad
%que se situan los pixeles
%
%Dominio: image
%Descripción: función que permite descomprimir una imagen comprimida.
%
%Dominio:image
% Descripcion:predicado que retorna un histograma a partir de los
% colores
%
%predicados auxiliares, uno permite contar los bits repetidos
%el otro, obtener una lista de todos los colores de una imagen.
%
%
contarRepetidosBit([],_,0).
contarRepetidosBit([Pixel|Resto],DatoBuscado,Repeticiones):-
    pixbit(_,_,Valor,_,Pixel),
    (Valor==DatoBuscado)->
    contarRepetidosBit(Resto,DatoBuscado,TotalRepeticiones),
    Repeticiones is TotalRepeticiones + 1;
    contarRepetidosBit(Resto,DatoBuscado,Repeticiones).

repetidosbit([],_,[]).

repetidosbit([Color|Resto],Pixeles,[NewHist|Histogramas]):-
    contarRepetidosBit(Pixeles,Color,Repeticiones),
    NewHist= [Color,Repeticiones],
    repetidosbit(Resto,Pixeles,Histogramas).


getcolorbit([],[]).
getcolorbit([Pixel|Rest],[Color|Colores]):-
pixbit(_,_,Valor,_,Pixel),
    Color is Valor,
    getcolorbit(Rest,Colores).




contarRepetidosrgb([],_,0).
contarRepetidosrgb([Pixel|Rest],[DatoR,DatoG,DatoB],Repeticiones):-
    pixrgb(_,_,R,G,B,_,Pixel),
    (   R==DatoR,G==DatoG,B==DatoB)->
    contarRepetidosrgb(Rest,[DatoR,DatoG,DatoB],TotalRepeticiones),
    Repeticiones is TotalRepeticiones+1;
    contarRepetidosrgb(Rest,[DatoR,DatoG,DatoB],Repeticiones).

repetidosrgb([],_,[]).
repetidosrgb([Color,Rest],Pixeles,[NewHist|Histogramas]):-
    contarRepetidosrgb(Pixeles,Color,Repeticiones),
    NewHist=[Color,Repeticiones],
    repetidosrgb(Rest,Pixeles,Histogramas).








getcolorrgb([],[]).
getcolorrgb([Pixel|Rest],[Color,Colores]):-
    pixrgb(_,_,R,G,B,_,Pixel),
    Color=[R,G,B],
    getcolorrgb(Rest,Colores).






contarRepetidosHex([],_,0).
contarRepetidosHex([Pixel|Resto],DatoBuscado,Repeticiones):-
    pixhex(_,_,Hex,_,Pixel),
    (Hex==DatoBuscado)->
    contarRepetidosHex(Resto,DatoBuscado,TotalRepeticiones),
    Repeticiones is TotalRepeticiones + 1;
    contarRepetidosHex(Resto,DatoBuscado,Repeticiones).

repetidoshex([],_,[]).

repetidoshex([Color|Resto],Pixeles,[NewHist|Histogramas]):-
    contarRepetidosHex(Pixeles,Color,Repeticiones),
    NewHist= [Color,Repeticiones],
    repetidoshex(Resto,Pixeles,Histogramas).


getcolorhex([],[]).
getcolorhex([Pixel|Rest],[Color|Colores]):-
pixbit(_,_,Hex,_,Pixel),
    Color is Hex,
    getcolorhex(Rest,Colores).








imageToHistogram(Image,Histograma):-
    image(_,_,Pixeles,Image),
    (imageIsBitmap(Image))->
    getcolorbit(Pixeles,Colores),
    sort(Colores,ColoresUnicos),
    repetidosbit(ColoresUnicos,Pixeles,Histograma);

    (imageIsPixmap(Image))->
    image(_,_,Pixeles,Image),
    getcolorrgb(Pixeles,Colores),
    sort(Colores,ColoresUnicos),
    repetidosrgb(ColoresUnicos,Pixeles,Histograma);

    (imageIsHexmap(Image))->
     image(_,_,Pixeles,Image),
     getcolorhex(Pixeles,Colores),
     sort(Colores,ColoresUnicos),
     repetidoshex(ColoresUnicos,Pixeles,Histograma).


















