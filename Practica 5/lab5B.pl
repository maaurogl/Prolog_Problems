%Hacer aguas: disponemos de un grifo de agua, un cubo de 5 litros y otro de 8 litros. 
%Se puede verter el contenido de un cubo en otro (hasta vaciar el primero, o hasta llenar el otro), llenar un cubo, o vaciar un cubo del todo. 
%Escribir un programa Prolog que diga la secuencia m ́as corta de operacionespara obtener exactamente 4 litros de agua en el cubo de 8 litros.

main:- EstadoInicial = [[1, 2, 5, 8], [0, 0, 0, 0], 0],    EstadoFinal   = [[0, 0, 0, 0], [1, 2, 5, 8], 1],
between(1,1000,CosteMax),               % Buscamos soluci ́on de coste 0; si no, de 1, etc.
camino( CosteMax, EstadoInicial, EstadoFinal, [EstadoInicial], Camino ),
reverse(Camino,Camino1), write(Camino1), write(' con coste '), write(CosteMax), nl, halt.

camino( 0, E,E, C,C ).
camino( CosteMax, EstadoActual, EstadoFinal, CaminoHastaAhora, CaminoTotal ):-
    CosteMax>0,
    unPaso( CostePaso, EstadoActual, EstadoSiguiente ),  % En B.1 y B.2, CostePaso es 1.
    \+member( EstadoSiguiente, CaminoHastaAhora ),
    CosteMax1 is CosteMax-CostePaso,
    camino(CosteMax1,EstadoSiguiente,EstadoFinal, [EstadoSiguiente|CaminoHastaAhora], CaminoTotal).

% Ejercicio B.3
%EstadoInicial = [1, 2, 5, 8],    EstadoFinal   = [0, 0, 0, 0]
unPaso(3, [[1, 2, A, B], [0, 0, C, D], 0], [[0, 0, A1, B1], [1, 2, C1, D1], 1]):- A = A1, B = B1, C = C1, D = D1.
unPaso(4, [[1, A, 5, B], [0, C, 0, D], 0], [[0, A1, 0, B1], [1, C1, 5, D1], 1]):- A = A1, B = B1, C = C1, D = D1.
unPaso(9, [[1, A, B, 8], [0, C, D, 0], 0], [[0, A1, B1, 0], [1, C1, D1, 8], 1]):- A = A1, B = B1, C = C1, D = D1.
unPaso(7, [[A, 2, 5, B], [C, 0, 0, D], 0], [[A1, 0, 0, B1], [C1, 2, 5, D1], 1]):- A = A1, B = B1, C = C1, D = D1.
unPaso(10, [[A, 2, B, 8], [C, 0, D, 0], 0], [[A1, 0, B1, 0], [C1, 2, D1, 8], 1]):- A = A1, B = B1, C = C1, D = D1.
unPaso(13, [[A, B, 5, 8], [C, D, 0, 0], 0], [[A1, B1, 0, 0], [C1, D1, 5, 8], 1]):- A = A1, B = B1, C = C1, D = D1.

unPaso(1, [[0, A, B, C], [1, D, E, F], 1], [[1, A1, B1, C1], [0, D1, E1, F1], 0]):- A = A1, B = B1, C = C1, D = D1, E = E1, F = F1.
unPaso(2, [[A, 0, B, C], [D, 2, E, F], 1], [[A1, 2, B1, C1], [D1, 0, E1, F1], 0]):- A = A1, B = B1, C = C1, D = D1, E = E1, F = F1.
unPaso(5, [[A, B, 0, C], [D, E, 5, F], 1], [[A1, B1, 5, C1], [D1, E1, 0, F1], 0]):- A = A1, B = B1, C = C1, D = D1, E = E1, F = F1.
unPaso(8, [[A, B, C, 0], [D, E, F, 8], 1], [[A1, B1, C1, 8], [D1, E1, F1, 0], 0]):- A = A1, B = B1, C = C1, D = D1, E = E1, F = F1.



% Ejercicio B.2
%EstadoInicial = [3, 0, 3, 0, 0],    EstadoFinal   = [0, 3, 0, 3, 1],

%estadoCorrecto([CI, CD, MI, MD]):- CI =< MI, CD =< MD.
%estadoCorrecto([_, _, MI, _]):- MI = 0.
%estadoCorrecto([_, _, _, MD]):- MD = 0.
%
%unPaso(1, [CI, CD, MI, MD, 0], [CIf, CDf, MIf, MDf, 1]):- CIf is CI-1, MIf is MI ,CD is 3-CI, MD is 3-MI, CDf is 3-CIf, MDf is 3-MIf, estadoCorrecto([CIf, CDf, MIf, MDf]).
%unPaso(1, [CI, CD, MI, MD, 0], [CIf, CDf, MIf, MDf, 1]):- CIf is CI, MIf is MI-1 ,CD is 3-CI, MD is 3-MI, CDf is 3-CIf, MDf is 3-MIf, estadoCorrecto([CIf, CDf, MIf, MDf]).
%unPaso(1, [CI, CD, MI, MD, 0], [CIf, CDf, MIf, MDf, 1]):- CIf is CI-1, MIf is MI-1 ,CD is 3-CI, MD is 3-MI, CDf is 3-CIf, MDf is 3-MIf, estadoCorrecto([CIf, CDf, MIf, MDf]).
%unPaso(1, [CI, CD, MI, MD, 0], [CIf, CDf, MIf, MDf, 1]):- CIf is CI-2, MIf is MI ,CD is 3-CI, MD is 3-MI, CDf is 3-CIf, MDf is 3-MIf, estadoCorrecto([CIf, CDf, MIf, MDf]).
%unPaso(1, [CI, CD, MI, MD, 0], [CIf, CDf, MIf, MDf, 1]):- CIf is CI, MIf is MI-2 ,CD is 3-CI, MD is 3-MI, CDf is 3-CIf, MDf is 3-MIf, estadoCorrecto([CIf, CDf, MIf, MDf]).
%
%unPaso(1, [CI, CD, MI, MD, 1], [CIf, CDf, MIf, MDf, 0]):- CDf is CD-1, MDf is MD ,CI is 3-CD, MI is 3-MD, CIf is 3-CDf, MIf is 3-MDf, estadoCorrecto([CIf, CDf, MIf, MDf]).
%unPaso(1, [CI, CD, MI, MD, 1], [CIf, CDf, MIf, MDf, 0]):- CDf is CD, MDf is MD-1 ,CI is 3-CD, MI is 3-MD, CIf is 3-CDf, MIf is 3-MDf, estadoCorrecto([CIf, CDf, MIf, MDf]).
%unPaso(1, [CI, CD, MI, MD, 1], [CIf, CDf, MIf, MDf, 0]):- CDf is CD-1, MDf is MD-1 ,CI is 3-CD, MI is 3-MD, CIf is 3-CDf, MIf is 3-MDf, estadoCorrecto([CIf, CDf, MIf, MDf]).
%unPaso(1, [CI, CD, MI, MD, 1], [CIf, CDf, MIf, MDf, 0]):- CDf is CD-2, MDf is MD ,CI is 3-CD, MI is 3-MD, CIf is 3-CDf, MIf is 3-MDf, estadoCorrecto([CIf, CDf, MIf, MDf]).
%unPaso(1, [CI, CD, MI, MD, 1], [CIf, CDf, MIf, MDf, 0]):- CDf is CD, MDf is MD-2 ,CI is 3-CD, MI is 3-MD, CIf is 3-CDf, MIf is 3-MDf, estadoCorrecto([CIf, CDf, MIf, MDf]).




% Ejercicio B.1

%EstadoInicial = [0,0],    EstadoFinal   = [0,4],

%unPaso(1, [C5,C8], [0, Sum]):- Sum is C5+C8, Sum =< 8. % Llenar el cubo 8 con el cubo 5 y que no sobre
%unPaso(1, [C5,C8], [Sum, 0]):- Sum is C5+C8, Sum =< 5. % Llenar el cubo 5 con el cubo 8 y que no sobre
%unPaso(1, [C5,C8], [SumFin, 8]):- Sum is C5+C8,  SumFin is Sum - 8, Sum > 8. % Llenar el cubo 8 con el cubo 5 y que sobre
%unPaso(1, [C5,C8], [5, SumFin]):- Sum is C5+C8,  SumFin is Sum - 5, Sum > 5. % Llenar el cubo 5 con el cubo 8 y que sobre
%unPaso(1, [_,C8], [5,C8]). % Llenar el cubo de 5 litros
%unPaso(1, [C5,_], [C5,8]). % Llenar el cubo de 8 litros
%unPaso(1, [_,C8], [0,C8]). % Vaciar el cubo de 5 litros
%unPaso(1, [C5,_], [C5,0]). % Vaciar el cubo de 8 litros
