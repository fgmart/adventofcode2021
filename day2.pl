/*
  Advent of Code 2021 Day 2

  PROLOG!

  Fred Martin, fredm@alum.mit.edu
  Sun Dec 19 13:14:03 2021

  evaluate "get_answer(A, "day2-input.txt")."

  and

  evaluate "get_answer_aim(A, "day2-input.txt")."


 */

:- use_module(library(pio)).


/*
?- get_answer(A, "day2-test.txt").
A = ["forward 5", "down 5", "forward 8", "up 3", "down 8", "forward 2"].

?- split_string("forward 5", " ", "", L).
L = ["forward", "5"].

?- split_string("forward 5", " ", "", L), [Command|[NumStr]] = L, number_string(N, NumStr).
L = ["forward", "5"],
Command = "forward",
NumStr = "5",
N = 5.

?- "foo" == "foo".
true.

?- "foo" == "bar".
false.

*/

/*
?- dive(["forward 5"], 0, 0, Pos, Depth).
Pos = 5,
Depth = 0.

?- dive(["forward 5"|["back 3"]], 0, 0, Pos, Depth).
Pos = 8,
Depth = 0.
*/

/* dive(CmdL, Pos, Depth, ResultPos, ResultDepth) */
dive([], Pos, Depth, Pos, Depth).
dive([Head|Tail], Pos, Depth, ResultPos, ResultDepth) :-
    split_string(Head, " ", "", CmdLine),
    [Cmd|[CmdArgStr]] = CmdLine,
    number_string(CmdArg, CmdArgStr),
    (Cmd = "forward" ->
	 NewPos is Pos + CmdArg,
	 NewDepth is Depth;
     Cmd = "back" ->
	 NewPos is Pos - CmdArg,
	 NewDepth is Depth;
     Cmd = "down" ->
	 NewPos is Pos,
	 NewDepth is Depth + CmdArg;
     Cmd = "up" ->
	 NewPos is Pos,
	 NewDepth is Depth - CmdArg),
    dive(Tail, NewPos, NewDepth, ResultPos, ResultDepth).
    
/* dive_aim(CmdL, Pos, Depth, ResultPos, ResultDepth) */
dive_aim([], Pos, Depth, _, Pos, Depth).
dive_aim([Head|Tail], Pos, Depth, Aim, ResultPos, ResultDepth) :-
    split_string(Head, " ", "", CmdLine),
    [Cmd|[CmdArgStr]] = CmdLine,
    number_string(CmdArg, CmdArgStr),
    (Cmd = "forward" ->
	 NewPos is Pos + CmdArg,
	 NewDepth is Depth + Aim * CmdArg,
	 NewAim is Aim;
     Cmd = "back" ->
	 NewPos is Pos - CmdArg,
	 NewDepth is Depth,
	 NewAim is Aim;
     Cmd = "down" ->
	 NewPos is Pos,
	 NewDepth is Depth,
	 NewAim is Aim + CmdArg;
     Cmd = "up" ->
	 NewPos is Pos,
	 NewDepth is Depth,
	 NewAim is Aim - CmdArg),
    dive_aim(Tail, NewPos, NewDepth, NewAim, ResultPos, ResultDepth).

get_answer(Answer, Fn) :-
    phrase_from_file(lines(Ls), Fn),
    char_lists_to_str_list(Ls, Result),
    dive(Result, 0, 0, ResultPos, ResultDepth),
    Answer is ResultPos * ResultDepth.

get_answer_aim(Answer, Fn) :-
    phrase_from_file(lines(Ls), Fn),
    char_lists_to_str_list(Ls, Result),
    dive_aim(Result, 0, 0, 0, ResultPos, ResultDepth),
    Answer is ResultPos * ResultDepth.

    

/* file input */
/* Use it with "phrase_from_file(lines(Ls), "INPUT_FN")" */
lines([])           --> call(eos), !.
lines([Line|Lines]) --> line(Line), lines(Lines).
eos([], []).
line([])     --> ( "\n" ; call(eos) ), !.
line([L|Ls]) --> [L], line(Ls).

char_lists_to_str_list([], Result, Result). /* yay we're done */
char_lists_to_str_list([Head|Tail], So_Far_List, Result) :-
    string_chars(Str, Head),
    append(So_Far_List, [Str], Updated_List),
    char_lists_to_str_list(Tail, Updated_List, Result).
char_lists_to_str_list(Char_Lists, Result) :-
    char_lists_to_str_list(Char_Lists, [], Result).


