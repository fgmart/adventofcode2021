/*
  Advent of Code 2021 Day 3

  PROLOG!

  Fred Martin, fredm@alum.mit.edu
  Fri Dec 24 07:11:39 2021

  evaluate "get_answer(A, "day3-input.txt")."

 */

:- use_module(library(pio)).


/* 

inputs: 

  [0, 0, 0, 0, 0] lists of prior count of ones (49)
  [48, 48, 49, 48, 48]  current one to count

output
  [0, 0, 1, 0, 1] (in this case - adding 1 to the pos'ns with 49
*/
/*
this two fcns are so complex/broken compared to the answer I just discovered!

count_ones_in_list(In_H, [], Cnt_H, [], Out) :-
    (  In_H = 49
    -> NewCnt is Cnt + 1
    ;  NewCnt is Cnt
    ),
    
count_ones_in_list(In_H, In_T, Cnt_H, Cnt_T, Out) :-
    (  In_H = 49
    -> NewCnt is Cnt + 1
    ;  NewCnt is Cnt
    ),
    [InH|InT] = In_T,
    [CntH|CntT] = Cnt_T,
    [NewCnt|Out] = NewOut,
    count_ones_in_list(InH, InT, CntH, CntT, NewOut).
*/

/* this is sort of mindblowing ... how does it work?
   wow it's like it searches for the list that will produce this output 
   probably can be used to do "list-half" as well 
   no it cannot. must have to do with the "D is..." statement

listDouble([],[]).
listDouble([H|T], [D|L]):-
        D is H * 2,
        listDouble(T,L).
*/

/*
?- countOnes([48, 49, 49], [0, 0, 0], Out).
Out = [0, 1, 1].
*/
countOnes([], [], []).
countOnes([InH|InT], [CntH|CntT], [OutH|OutT]) :-
    (  InH = 49
    -> OutH is CntH + 1
    ;  OutH is CntH
    ),
    countOnes(InT, CntT, OutT).

/*
using maplist

double(X, D) :-
    D is X * 2.
listDouble(List, DList) :-
    maplist(double, List, DList).
*/


/* OK now need to recurse through list of input-strings and accumulate answer
*/
countOnesLs([], Result, Result).
countOnesLs([H|T], CntIn, Result) :-
    countOnes(H, CntIn, NewCntOut),
    countOnesLs(T, NewCntOut, Result).

buildZerosLs(N, Result) :- buildZerosLs(N, [], Result).
buildZerosLs(0, Result, Result).
buildZerosLs(N, In, Out) :-
    Dec is N - 1,
    buildZerosLs(Dec, [0|In], Out).

majority(N, D, Maj) :-
    Q is N * 2,
    (  Q >= D
    -> Maj is 1
    ;  Maj is 0).

majorityLs([], [], _).
majorityLs([H|T], [N|L], D) :-
    majority(H, D, N),
    majorityLs(T, L, D).

binlist2Dec(Ls, Res) :- binlist2Dec(Ls, 0, Res).
binlist2Dec([], Res, Res).
binlist2Dec([H|T], SoFar, Res) :-
    (  H = 1
    -> New is SoFar * 2 + 1
    ;  New is SoFar * 2),
    binlist2Dec(T, New, Res).

invertBit(X, Y) :-
    (  X = 0
    -> Y is 1
    ;  Y is 0).

get_answer(Ans, Fn) :-
    phrase_from_file(lines(Ls), Fn),
    [H|_] = Ls,			  	/* strip off first entry */
    length(H, Len),			/* and figure out how long it is */
    buildZerosLs(Len, ZerosLs),		/* make a list of 0s that long */
    countOnesLs(Ls, ZerosLs, GammaLs),	/* the main predicate - count 1s
					   in all input into the "Out" list */
    length(Ls, ListLen),		/* how many total lines we have */
    majorityLs(GammaLs, GammaBinLs, ListLen), /* convert the Out str to 1/0 str */
    binlist2Dec(GammaBinLs, Gamma),
    maplist(invertBit, GammaBinLs, EpisonBinLs),
    binlist2Dec(EpisonBinLs, Epsilon),
    Ans is Gamma * Epsilon.


/* file input */
/* Use it with "phrase_from_file(lines(Ls), "INPUT_FN")" */
lines([])           --> call(eos), !.
lines([Line|Lines]) --> line(Line), lines(Lines).
eos([], []).
line([])     --> ( "\n" ; call(eos) ), !.
line([L|Ls]) --> [L], line(Ls).



