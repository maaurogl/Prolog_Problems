:- use_module(library(clpfd)).

%% A (6-side) "letter dice" has on each side a different letter.  Find
%% four of them, with the 24 letters abcdefghijklmnoprstuvwxy such
%% that you can make all the following words: bake, onyx, echo, oval,
%% gird, smug, jump, torn, luck, viny, lush, wrap.

%Some helpful predicates:
word( [b,a,k,e] ).
word( [o,n,y,x] ).
word( [e,c,h,o] ).
word( [o,v,a,l] ).
word( [g,i,r,d] ).
word( [s,m,u,g] ).
word( [j,u,m,p] ).
word( [t,o,r,n] ).
word( [l,u,c,k] ).
word( [v,i,n,y] ).
word( [l,u,s,h] ).
word( [w,r,a,p] ).

num(X,N):- nth1(N,[a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,r,s,t,u,v,w,x,y],X).


main:-
    length(D1,6),
    length(D2,6),
    length(D3,6),
    length(D4,6),
    append(D1,D2,A), append(A,D3,B), append(B,D4, Vars),
    Vars ins 1..24,
    all_distinct(Vars),
    
    findall( N-M, notSameDice(N,M), L0),  sort(L0,L),  %L es la lista de parejas de letras que no han de salir en el mismo dado 
                                                       %  hacemos sort para no repetir parejas

    % lo siguiente es para romper simetrias; restricciones que ponemos imponer sin eliminar la solucion, y ser más eficientes:
    sorted(D1),   %definido abajo: cada dado [A,B,C,D,E,F] está ordenado:  A #< B,  B #< C, ...  E #< F
    sorted(D2),
    sorted(D3),
    sorted(D4),
    D1=[1|_],     %1 and 2 are not in the same dice due to [b,a,k,e]
    D2=[2|_],  
    D3=[D31|_],
    D4=[D41|_], D31 #< D41,
    
    makeConstraints(D1,L),   % cada pareja de letras que no ha de salir en el mismo dado
    makeConstraints(D2,L),
    makeConstraints(D3,L),
    makeConstraints(D4,L), !, 
    labeling([ff],Vars),
    writeDice(D1), nl,
    writeDice(D2), nl,
    writeDice(D3), nl,
    writeDice(D4), nl, nl, halt.
    

writeDice(D):- findall(X,(member(N,D),num(X,N)),L), write(L),!.
sorted([A,B,C,D,E,F]):- A #< B,  B #< C,  C #< D,  D #< E,  E #< F,  !.
notSameDice(N,M):- word(W), member(A,W), member(B,W), num(A,N), num(B,M), N<M.

makeConstraints(_,[]).
makeConstraints([A,B,C,D,E,F],[N-M|L]):-
    makeConstraints([A,B,C,D,E,F],L),
    A #\= N #\/ B #\= M,  A #\= N #\/ C #\= M,  A #\= N #\/ D #\= M,  A #\= N #\/ E #\= M,  A #\= N #\/ F #\= M,
                          B #\= N #\/ C #\= M,  B #\= N #\/ D #\= M,  B #\= N #\/ E #\= M,  B #\= N #\/ F #\= M,
                                                C #\= N #\/ D #\= M,  C #\= N #\/ E #\= M,  C #\= N #\/ F #\= M,
                                                                      D #\= N #\/ E #\= M,  D #\= N #\/ F #\= M,
                                                                                            E #\= N #\/ F #\= M,!.

