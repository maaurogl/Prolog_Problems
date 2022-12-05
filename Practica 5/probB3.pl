main:- EstadoInicial = [[1,2,5,8], lado1], EstadoFinal = [[],lado2],
  %between(1,1000,CosteMax), % Buscamos soluci´on de coste 0; si no, de 1, etc.
  nat(CosteMax),
  camino( CosteMax, EstadoInicial, EstadoFinal, [EstadoInicial], Camino ),
  reverse(Camino,Camino1), write(Camino1), write("con coste" ), write(CosteMax), nl, halt.

camino( 0, E,E, C,C ).
camino( CosteMax, EstadoActual, EstadoFinal, CaminoHastaAhora, CaminoTotal ):-
  CosteMax>0,
  unPaso( CostePaso, EstadoActual, EstadoSiguiente ), % En B.1 y B.2, CostePaso es 1.
  \+member( EstadoSiguiente, CaminoHastaAhora ),
  CosteMax1 is CosteMax-CostePaso,
  camino(CosteMax1,EstadoSiguiente,EstadoFinal, [EstadoSiguiente|CaminoHastaAhora], CaminoTotal).

nat(0).
nat(N):- nat(N1), N is N1 + 1.

unPaso(C, [I,lado1], [II,lado2]):- %cruza uno de izquierda a derecha
  select(C,I,II).

unPaso(C, [I,lado1], [II,lado2]):- %cruzan dos de izquierda a derecha
  select(A,I,AUX), select(B,AUX, II), C is max(A,B).

unPaso(C, [I,lado2], [II,lado1]):- %cruza uno de derecha a izquierda
  member(C,[1,2,5,8]),
  \+member(C,I),
  sort([C|I],II).

unPaso(C, [I,lado2], [II,lado1]):- %cruzan dos de derecha a izquierda
  member(A,[1,2,5,8]),
  member(B,[1,2,5,8]),
  A \= B,
  \+member(A,I),
  \+member(B,I),
  sort([A,B|I],II),
  C is max(A,B).
