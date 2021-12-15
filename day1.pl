/*
  Advent of Code 2021 Day 1

  PROLOG!

  Fred Martin, fredm@alum.mit.edu

  evaluate "get_answer(A, "day1-input.txt")." to see result.

  or "get_answer3..."

 */



/* hardest part of this was getting started and staring at the blank
   swipl prompt, and not remembering even how to load a file.

   I found the "getting started quickly" doc with its "likes.pl" sample code
   which was a big help:

   https://www.swi-prolog.org/pldoc/man?section=quickstart

   I quickly remembered the essential way of thinking in Prolog of 
   getting your answer by unifying with an unassigned variable.

   Other key things to remember were how to pattern-match with variables
   to unpack a list... I ended up writing the length-of-list fcn "len"
   before getting going on the problem itself.

   Still not sure how to declare a static list in the code.

   Didn't initially remember that one may have the same predicate with
   different args, so that the inner recursive iterator predicate may have
   the same name as the public one.

   Remembered this when reviewing my prior code to process the raw char 
   input list-of-lists and transform it into a list of numbers.
*/

:- use_module(library(pio)).

/*
  count number of times a measurement increases from the previous measurement
 
  will have list of numbers

  once past startup, have:
    prior count
    current number
    remainder of list
  then
    list empty -> prior count is answer
    head of list is bigger than current number ->
      recurse with prior_count + 1, new head, tail.
    else
      recurse with prior_count, new head, tail.

   startup:
     assume list has at least one number.
     begin recursion with 0, head, tail.
 */



/*
?- count([1, 2, 3], Result).
Result = 2 .

?- count([1, 2, 3, 4], Result).
Result = 3 .

?- count([1, 2, 3, 2, 3], Result).
Result = 3 .

?- count([1, 2, 3, 2, 3, 4], Result).
Result = 4 .

?- count([199, 200, 208, 210, 200, 207, 240, 269, 260, 263], Result).
Result = 7 .

*/

/* rewriting to have iter pred have same name as public pred */

count(List, Result) :-
    [Head|Tail] = List,
    count(Head, Tail, 0, Result).
count(_, [], Result, Result).
count(First, [Head|Tail], Count, Result) :-
    (  First < Head
    -> NewCount is Count + 1, 
       count(Head, Tail, NewCount, Result)
    ;  count(Head, Tail, Count, Result)
    ).


/*
now the interesting part is done and all that remains is the plumbing!
*/

/* part two -- keeping a running group of last-3 readings. */
/* this was pretty easy copying from my earlier code and having seen
   something like this before */

count3(List, Result) :-
    [HeadA|[HeadB|[HeadC|Tail]]] = List,
    Sum is HeadA + HeadB + HeadC,
    count3(Sum, HeadB, HeadC, Tail, 0, Result).
count3(_, _, _, [], Result, Result).
count3(EarlierSum, HeadA, HeadB, [HeadC|Tail], Count, Result) :-
    NewSum is HeadA + HeadB + HeadC,
    (  EarlierSum < NewSum
    -> NewCount is Count + 1,
       count3(NewSum, HeadB, HeadC, Tail, NewCount, Result)
    ;  count3(NewSum, HeadB, HeadC, Tail, Count, Result)
    ).


/* get_answer(A, "day1-input.txt") */

get_answer(Answer, Fn) :-
    phrase_from_file(lines(Ls), Fn),
    char_lists_to_num_list(Ls, Result),
    count(Result, Answer).

get_answer3(Answer, Fn) :-
    phrase_from_file(lines(Ls), Fn),
    char_lists_to_num_list(Ls, Result),
    count3(Result, Answer).


    
/* how do I strip off the head of a list and have it as an arg to my
    iter fcn? */

/* 
?- len([1, 2, 3], X).
X = 3.


len(List, Result) :- length_iter(List, 0, Result).
len([], Result, Result).
len([_|Tail], SoFar, Result) :-
    More is SoFar + 1,
    len(Tail, More, Result).
*/


/* file input */
/* I don't really understand this code; */
/* Use it with "phrase_from_file(lines(Ls), "INPUT_FN")" */
lines([])           --> call(eos), !.
lines([Line|Lines]) --> line(Line), lines(Lines).
eos([], []).
line([])     --> ( "\n" ; call(eos) ), !.
line([L|Ls]) --> [L], line(Ls).

/*
car([X|_],X).
*/
/* LOL map car onto the list */


/* thank you Mike Brayshaw, Paul Brna, and Tamsin Treasure-Jones
for this list-search predicate, from:
https://www.doc.gold.ac.uk/~mas02gw/prolog_tutorial/prologpages/lists.html
*/
/*
in_list(Item,[Item|_]).
in_list(Item,[_|Tail]) :-
    in_list(Item,Tail).
*/

char_lists_to_num_list([], Result, Result).
char_lists_to_num_list([Head|Tail], So_Far_List, Result) :-
    string_chars(Str, Head),
    number_string(Num, Str),
    append(So_Far_List, [Num], Updated_List),
    char_lists_to_num_list(Tail, Updated_List, Result).
char_lists_to_num_list(Char_Lists, Result) :-
    char_lists_to_num_list(Char_Lists, [], Result).
			   
/*
?- phrase_from_file(lines(Ls), "day1-input.txt"), char_lists_to_str_list(Ls, Result).
Ls = [[49, 49, 56], [49, 50, 49], [49, 50, 51], [49, 50, 53], [49, 51, 52], [49, 51, 50], [49, 51|...], [49|...], [...|...]|...],
Result = ["118", "121", "123", "125", "134", "132", "137", "135", "136"|...].
*/

