symbolicOutput(0).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% To use this prolog template for other optimization problems, replace the code parts 1,2,3,4 below. %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Extend this Prolog source to plan the workers of an Amazon storage center.
% See the input example (and the helpful definitions) below. The input says:
%   -how many workers there are, and which ones of them are supervisors
%   -how many days in total we need to plan, and how many of these days we can have no supervisor working
%   -for each day of the planned period, how many workers are needed at least
%   -for each worker, on which days he/she is blocked (cannot work)
% Moreover, no worker can work more than 3 consecutive days.
% Find the planning that minimizes the number of days without any supervisor working.
% Note that there are several ... to be filled: total 7 points.

%% The following is a correct solution with cost 3 for the example below, with 31 days and 9 workers:
%% 
%% Solution found with cost 3
%% 
%%                  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31
%%  1: (supervisor)             x     x  x  x        x        x  x     x  x  x     x  x  x     x     x  x     x 
%%  2:              x  x     x  x  x     x  x     x  x  x        x  x  x     x        x  x  x     x  x  x     x 
%%  3:              x  x  x     x  x  x     x  x  x     x     x  x  x     x  x     x  x  x        x  x     x  x 
%%  4: (supervisor) x  x  x        x  x  x     x  x  x     x  x           x     x  x  x     x  x  x        x  x 
%%  5:              x  x     x  x  x        x  x        x  x  x     x  x  x     x  x  x     x  x  x     x  x  x 
%%  6:              x  x     x  x  x     x  x     x  x  x     x  x  x     x     x  x  x     x     x        x  x 
%%  7:              x  x     x  x     x  x  x     x  x  x     x  x  x     x  x  x     x  x  x     x  x  x       
%%  8:              x     x  x  x     x  x     x  x  x     x     x  x  x     x  x  x     x  x     x  x  x     x 
%%  9:              x     x  x     x     x     x     x  x  x        x  x  x     x  x  x     x  x  x     x  x  x 
%% No supervisor:           $$$                        $$$         $$$                                          


%%%%%%%%%%%%%%%%%%%%% Toy input example:   %%%%%%%%%%%%%%%%
numWorkers(9).                 %here in this example, we have 9 different workers
supervisors([1,4]).            %here, workers 1 and 4 are the supervisors
numDays(31).                   %here, the planned period is one month (31 days)
maxDaysWithoutSupervisor(4).   %here, we can have at most 4 days without any supervisor working
needs([6,5,4,6,6,6,5,5,4,5,6,6,5,4,4,5,4,5,4,5,4,5,6,5,6,4,6,5,5,4,4]). %on day 1 we need 6 workers; on day 2 we need 5, etc.

blocked(1,[1,2,3,4,6,11,13,14,17,30]).   %worker 1 is blocked (cannot work) on days 1,2,3,4,6,11,13,14,17,30
blocked(2,[7,14,15,21,22]).
blocked(3,[14,21,26,29]).
blocked(4,[4,5,16,17,18,20,28,29]).
blocked(5,[3,8,11,12,20]).
blocked(6,[3,18,20,26,28,29]).
blocked(7,[3,14,31]).
blocked(8,[15,26]).
blocked(9,[7,9,11,16,20]).
%%%%%%%%%%%%%%%%%%%%% End input example.   %%%%%%%%%%%%%%%%


%%%%%% Some helpful definitions to make the code cleaner:
worker(W):- numWorkers(Num), between(1,Num,W).
day(D):-    numDays(Num),    between(1,Num,D).
supervisor(W):- supervisors(L), member(W,L).
numWorkersNeededForDay(D,Num):- day(D), needs(L), nth1(D,L,Num).  %on day D we need Num workers.
isBlocked(W,D):- blocked(W,L), member(D,L).
fourConsecutiveDays(D1,D2,D3,D4):- day(D1), D2 is D1+1, D3 is D1+2, D4 is D1+3, day(D4).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1.- Declare SAT variables to be used
satVariable( works(W,D)      ):- worker(W), day(D).  %  "worker W works on day D"
satVariable( noSupervisor(D) ):-            day(D).  %  "there is no supervisor on day D"

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2. This predicate writeClauses(MaxCost) generates the clauses that guarantee that
%    a solution with cost at most MaxCost is found

% max number of days without supervisor
writeClauses(infinite):- maxDaysWithoutSupervisor(M), writeClauses(M).
writeClauses(Max):-
    eachDayEnoughWorkers,
    blocked,
    atMostThreeConsecutiveDays,
    defineNoSupervisor,
    maxDaysWithoutSupervis(Max),
    true,!.
writeClauses(_):- told, nl, write('writeClauses failed!'), nl,nl, halt.


eachDayEnoughWorkers:- day(D), numWorkersNeededForDay(D,Num), findall(works(W,D), worker(W), Lits), atLeast(Num,Lits),fail.
eachDayEnoughWorkers.

blocked:- worker(W), isBlocked(W,D), writeClause([-works(W,D)]), fail.
blocked.

atMostThreeConsecutiveDays:- fourConsecutiveDays(D1,D2,D3,D4), worker(W), writeClause([-works(W,D1),-works(W,D2),-works(W,D3),-works(W,D4)]), fail.
atMostThreeConsecutiveDays.

% For each each day D we need one clause, expressing that some of the supervisors works or noSupervisor(D) is true:
defineNoSupervisor:- day(D), supervisor(S1), supervisor(S2), S1 < S2, writeClause([-works(S1,D),-works(S2,D),noSupervisor(D)]), fail.
defineNoSupervisor.

maxDaysWithoutSupervis(Max):- findall(noSupervisor(D), day(D), Lits), atMost(Max,Lits), fail.
maxDaysWithoutSupervis(_).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 3. This predicate displays a given solution M:

%displaySol(M):- write(M), nl, fail.
displaySol(_):- write('                 1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31'), fail.
displaySol(M):- worker(W), nl, writeIfSupervisor(W), day(D), writeDay(M,W,D), fail.
displaySol(M):- nl, write('No supervisor:  '), day(D), writeS(M,D), fail.
displaySol(_):- nl,nl.

writeDay(M,W,D):- member( works(W,D), M ), write(' x '), !.
writeDay(_,_,_):-                          write('   '), !.

writeS(M,D):- supervisor(W), member(works(W,D),M), write('   '),!.
writeS(_,_):-                                      write('$$$'),!.

writeIfSupervisor(W):- supervisor(W), write2(W), write('(supervisor)'),!.
writeIfSupervisor(W):-                write2(W), write('            '),!.

write2(W):- W>9, !, write(W), write(': ').
write2(W):- write(' '), write(W), write(': ').


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 4. This predicate computes the cost of a given solution M:
costOfThisSolution(M,Cost):- findall(D, member(noSupervisor(D),M), Dias),length(Dias,Cost),!.



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% No need to modify anything below this line:

main:-  symbolicOutput(1), !, writeClauses(infinite), halt.   % print the clauses in symbolic form and halt
main:-
    told, write('Looking for initial solution with arbitrary cost...'), nl,
    initClauseGeneration,
    tell(clauses), writeClauses(infinite), told,
    tell(header),  writeHeader,  told,
    numVars(N), numClauses(C), 
    write('Generated '), write(C), write(' clauses over '), write(N), write(' variables. '),nl,
    shell('cat header clauses > infile.cnf',_),
    write('Launching picosat...'), nl,
    shell('picosat -v -o model infile.cnf', Result),  % if sat: Result=10; if unsat: Result=20.
    treatResult(Result,[]),!.

treatResult(20,[]       ):- write('No solution exists.'), nl, halt.
treatResult(20,BestModel):-
    nl,costOfThisSolution(BestModel,Cost), write('Unsatisfiable. So the optimal solution was this one with cost '),
    write(Cost), write(':'), nl, displaySol(BestModel), nl,nl,halt.
treatResult(10,_):- %   shell('cat model',_),
    nl,write('Solution found '), flush_output,
    see(model), symbolicModel(M), seen,
    costOfThisSolution(M,Cost),
    write('with cost '), write(Cost), nl,nl,
    displaySol(M), 
    Cost1 is Cost-1,   nl,nl,nl,nl,nl,  write('Now looking for solution with cost '), write(Cost1), write('...'), nl,
    initClauseGeneration, tell(clauses), writeClauses(Cost1), told,
    tell(header),  writeHeader,  told,
    numVars(N),numClauses(C),
    write('Generated '), write(C), write(' clauses over '), write(N), write(' variables. '),nl,
    shell('cat header clauses > infile.cnf',_),
    write('Launching picosat...'), nl,
    shell('picosat -v -o model infile.cnf', Result),  % if sat: Result=10; if unsat: Result=20.
    treatResult(Result,M),!.
treatResult(_,_):- write('cnf input error. Wrote something strange in your cnf?'), nl,nl, halt.
    

initClauseGeneration:-  %initialize all info about variables and clauses:
	retractall(numClauses(   _)),
	retractall(numVars(      _)),
	retractall(varNumber(_,_,_)),
	assert(numClauses( 0 )),
	assert(numVars(    0 )),     !.

writeClause([]):- symbolicOutput(1),!, nl.
writeClause([]):- countClause, write(0), nl.
writeClause([Lit|C]):- w(Lit), writeClause(C),!.
w(-Var):- symbolicOutput(1), satVariable(Var), write(-Var), write(' '),!. 
w( Var):- symbolicOutput(1), satVariable(Var), write( Var), write(' '),!. 
w(-Var):- satVariable(Var),  var2num(Var,N),   write(-), write(N), write(' '),!.
w( Var):- satVariable(Var),  var2num(Var,N),             write(N), write(' '),!.
w( Lit):- told, write('ERROR: generating clause with undeclared variable in literal '), write(Lit), nl,nl, halt.


% given the symbolic variable V, find its variable number N in the SAT solver:
var2num(V,N):- hash_term(V,Key), existsOrCreate(V,Key,N),!.
existsOrCreate(V,Key,N):- varNumber(Key,V,N),!.                            % V already existed with num N
existsOrCreate(V,Key,N):- newVarNumber(N), assert(varNumber(Key,V,N)), !.  % otherwise, introduce new N for V

writeHeader:- numVars(N),numClauses(C), write('p cnf '),write(N), write(' '),write(C),nl.

countClause:-     retract( numClauses(N0) ), N is N0+1, assert( numClauses(N) ),!.
newVarNumber(N):- retract( numVars(   N0) ), N is N0+1, assert(    numVars(N) ),!.

% Getting the symbolic model M from the output file:
symbolicModel(M):- get_code(Char), readWord(Char,W), symbolicModel(M1), addIfPositiveInt(W,M1,M),!.
symbolicModel([]).
addIfPositiveInt(W,L,[Var|L]):- W = [C|_], between(48,57,C), number_codes(N,W), N>0, varNumber(_,Var,N),!.
addIfPositiveInt(_,L,L).
readWord( 99,W):- repeat, get_code(Ch), member(Ch,[-1,10]), !, get_code(Ch1), readWord(Ch1,W),!. % skip line starting w/ c
readWord(115,W):- repeat, get_code(Ch), member(Ch,[-1,10]), !, get_code(Ch1), readWord(Ch1,W),!. % skip line starting w/ s
readWord(-1,_):-!, fail. %end of file
readWord(C,[]):- member(C,[10,32]), !. % newline or white space marks end of word
readWord(Char,[Char|W]):- get_code(Char1), readWord(Char1,W), !.
:-dynamic(varNumber / 3).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Express that Var is equivalent to the disjunction of Lits:
expressOr( Var, Lits) :- symbolicOutput(1), write( Var ), write(' <--> or('), write(Lits), write(')'), nl, !. 
expressOr( Var, Lits ):- member(Lit,Lits), negate(Lit,NLit), writeClause([ NLit, Var ]), fail.
expressOr( Var, Lits ):- negate(Var,NVar), writeClause([ NVar | Lits ]),!.

% Express that Var is equivalent to the conjunction of Lits:
expressAnd( Var, Lits) :- symbolicOutput(1), write( Var ), write(' <--> and('), write(Lits), write(')'), nl, !. 
expressAnd( Var, Lits):- member(Lit,Lits), negate(Var,NVar), writeClause([ NVar, Lit ]), fail.
expressAnd( Var, Lits):- findall(NLit, (member(Lit,Lits), negate(Lit,NLit)), NLits), writeClause([ Var | NLits]), !.


%%%%%% Cardinality constraints on arbitrary sets of literals Lits:

exactly(K,Lits):- symbolicOutput(1), write( exactly(K,Lits) ), nl, !.
exactly(K,Lits):- atLeast(K,Lits), atMost(K,Lits),!.

atMost(K,Lits):- symbolicOutput(1), write( atMost(K,Lits) ), nl, !.
atMost(K,Lits):-   % l1+...+ln <= k:  in all subsets of size k+1, at least one is false:
	negateAll(Lits,NLits),
	K1 is K+1,    subsetOfSize(K1,NLits,Clause), writeClause(Clause),fail.
atMost(_,_).

atLeast(K,Lits):- symbolicOutput(1), write( atLeast(K,Lits) ), nl, !.
atLeast(K,Lits):-  % l1+...+ln >= k: in all subsets of size n-k+1, at least one is true:
	length(Lits,N),
	K1 is N-K+1,  subsetOfSize(K1, Lits,Clause), writeClause(Clause),fail.
atLeast(_,_).

negateAll( [], [] ).
negateAll( [Lit|Lits], [NLit|NLits] ):- negate(Lit,NLit), negateAll( Lits, NLits ),!.

negate( -Var,  Var):-!.
negate(  Var, -Var):-!.

subsetOfSize(0,_,[]):-!.
subsetOfSize(N,[X|L],[X|S]):- N1 is N-1, length(L,Leng), Leng>=N1, subsetOfSize(N1,L,S).
subsetOfSize(N,[_|L],   S ):-            length(L,Leng), Leng>=N,  subsetOfSize( N,L,S).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
