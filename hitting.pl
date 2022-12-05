% This exercise gives 3 points.
% Given a number of words, find a MINIMAL-LENGTH list of caracters L such that each word has at least one character in L.
% For the words below, one such an L is, for example, [a,e,n,o],

word( [s,o,m,e] ).
word( [a,p,p,a,r,e,n,t,l,y] ).
word( [s,i,m,p,l,e] ).
word( [p,r,o,b,l,e,m,s] ).
word( [a,r,e] ).
word( [i,n] ).
word( [f,a,c,t] ).
word( [h,a,r,d] ).
word( [p,u,z,z,l,e,s] ).
word( [w,h,e,r,e] ).
word( [c,h,o,i,c,e,s] ).
word( [c,a,n] ).
word( [b,e] ).
word( [c,o,m,b,i,n,e,d] ).
word( [i,n] ).
word( [a,n] ).
word( [e,x,p,o,n,e,n,t,i,a,l] ).
word( [n,u,m,b,e,r] ).
word( [o,f] ).
word( [w,a,y,s] ).

word( [d,u,e] ).
word( [t,o] ).
word( [c,o,n,s,t,r,a,i,n,t,s] ).
word( [m,o,s,t] ).
word( [c,o,m,b,i,n,a,t,i,o,n,s] ).
word( [a,r,e] ).
word( [n,o,n,o,p,t,i,m,a,l] ).
word( [o,r] ).
word( [f,o,r,b,i,d,d,e,n]).




main:- findall( C, (word(W), member(C,W)), Chars0),
       sort(Chars0,Chars),   % sort to avoid repetitions
       between(1,1000,Size),
       length(Chars,Lim),
       length(L,Size),
       L ins 0..Lim,
       allWordsCovered(L),
       label(L),
       write(L), nl, halt.

posEnL(X,L,N):-nth1(N,L,X).

allWordsCovered(L):- word(W), not(wordCovered(W,L)), !, fail.
allWordsCovered(_).


% word W has some letter in L
wordCovered(W,L):- member(X,W), member(X,L),!.


subsetOfSize(0,_,[]):-!.
subsetOfSize(N,[X|L],[X|S]):- N1 is N-1, length(L,Leng), Leng>=N1, subsetOfSize(N1,L,S).
subsetOfSize(N,[_|L],   S ):-            length(L,Leng), Leng>=N,  subsetOfSize( N,L,S).

	   
