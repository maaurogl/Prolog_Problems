:- use_module(library(clpfd)).

ejemplo(0,   26, [1,2,5,10] ).  % Solution: [1,0,1,2]
ejemplo(1,  361, [1,2,5,13,17,35,157]).



expr([],[],0).
expr([X|L],[Y|L1], Expr + X*Y):- expr(L,L1,Expr).

exprSuma([X],X):- !.
exprSuma([X|Vars], X+Expr):- exprSuma(Vars,Expr).

main:-
    ejemplo(1,Amount,Coins),
    nl, write('Paying amount '), write(Amount), write(' using the minimal number of coins of values '), write(Coins), nl,nl,
    length(Coins,N),
    length(Vars,N), % get list of N prolog vars

    %Dominio
    Vars ins 0..Amount,
    %Constrains
    expr(Vars,Coins,Expr),
    Expr #= Amount,
    exprSuma(Vars,ExprSuma),

    %Labeling
    labeling( [min(ExprSuma)], Vars),


    nl, write(Vars), nl,nl, halt.
