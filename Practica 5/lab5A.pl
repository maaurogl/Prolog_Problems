%[Num, Color, Profesion, Animal, Bebida, Nacionalidad]
esColor(A):- member(A, [roja,verde,blanca,amarilla,azul]).
esProfesion(B):- member(B, [pintor,escultor,actor,notario,medico]).
esAnimal(C):-    member(C, [perro,caracol,caballo,ardilla,gato]).
esBebida(D):-    member(D, [ron,conac,cava,whisky,agua]).
esPais(E):-      member(E, [peru,francia,china,hungria,japon]).

viveAlLado(I, N):- I is N+1.
viveAlLado(I, N):- I is N-1.

main:-  
        Sol = [[1,A1,B1,C1,D1,E1], [2,A2,B2,C2,D2,E2], [3,A3,B3,C3,D3,E3], [4,A4,B4,C4,D4,E4], [5,A5,B5,C5,D5,E5]],

        %1 - El que vive en la casa roja es de Peru
        member([_,roja,_,_,_,peru],Sol),
        %2 - Al frances le gusta el perro
        member([_,_,_,perro,_,francia],Sol),
        %3 - El pintor es japon ́es
        member([_,_,pintor,_,_,japon],Sol),
        %4 - Al chino le gusta el ron
        member([_,_,_,_,ron,china],Sol),
        %5 - El h ́ungaro vive en la primera casa
        member([1,_,_,_,_,hungria],Sol),
        %6 - Al de la casa verde le gusta el co ̃nac
        member([_,verde,_,_,conac,_],Sol),
        %7 - La casa verde est ́a justo a la izquierda de la blanca
        member([I,verde,_,_,_,_],Sol), member([N,blanca,_,_,_,_],Sol), between(1,4,I), N is I+1,
        %8 - El escultor cr ́ıa caracoles
        member([_,_,escultor,caracol,_,_],Sol),
        %9 - El de la casa amarilla es actor
        member([_,amarilla,actor,_,_,_],Sol),
        %10 - El de la tercera casa bebe cava
        member([3,_,_,_,cava,_],Sol),
        %11 - El que vive al lado del actor tiene un caballo
        member([I2,_,actor,_,_,_],Sol), member([N2,_,_,caballo,_,_],Sol), viveAlLado(I2, N2),
        %12 - El h ́ungaro vive al lado de la casa azul
        member([I3,azul,_,_,_,_],Sol), member([N3,_,_,_,_,hungria],Sol), viveAlLado(I3, N3),
        %13 - Al notario la gusta el whisky
        member([_,_,notario,_,whisky,_],Sol),
        %14 - El que vive al lado del m ́edico tiene un ardilla
        member([I4,_,medico,_,_,_],Sol), member([N4,_,_,ardilla,_,_],Sol), viveAlLado(I4, N4),

        esColor(A1), esColor(A2), esColor(A3), esColor(A4), esColor(A5),
        esProfesion(B1), esProfesion(B2), esProfesion(B3), esProfesion(B4), esProfesion(B5), 
        esAnimal(C1), esAnimal(C2), esAnimal(C3), esAnimal(C4), esAnimal(C5),
        esBebida(D1), esBebida(D2), esBebida(D3), esBebida(D4), esBebida(D5),
        esPais(E1), esPais(E2), esPais(E3), esPais(E4), esPais(E5),

        write(Sol).

