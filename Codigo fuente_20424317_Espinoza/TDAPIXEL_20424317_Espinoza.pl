%Laboratorio 2 Prolog
%Nombre: Leonardo Espinoza
%Profesor: Miguel Truffa
%
%
%
%%%%%%%%%TDA PIXEL%%%%%%%%%
%
%
%
%
%
%
%
%
%
%Metas Primarias:
%Crear pixeles
%
%
%Metas Secundarias:
%%%%%%Representaci�n%%%%%%%%%5
% El TDA PIXEL representa los pixeles, donde cada pixel tendrá información adicional para usarse en la creacion de imagenes
% %%%%Contructor y Pertenencia%%%%%%%
%
%Clausulas
%Hechos
%
%Dominio: pixel
%Descripcion: Predicado para construir pixeles
pixbit(X, Y, Valor, Prof, [X, Y, Valor, Prof]).
pixrgb(X, Y, R, G, B, Prof, [X, Y, R, G, B, Prof]).
pixhex(X, Y, Hex, Prof, [X, Y, Hex, Prof]).

%
%
%
%
%
%
%
%
%
