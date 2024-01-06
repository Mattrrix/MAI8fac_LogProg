%member
member(X, [X|_]).
member(X, [_|Tail]) :-
    member(X, Tail).
    
%append
append([], X, X).
append([X|T], Y, [X|A]) :-
    append(T, Y, A).

move(A,B):-
    append(Begin,["_","w"|Tail],A),
    append(Begin,["w","_"|Tail],B).

move(A,B):-
    append(Begin,["b","_"|Tail],A),
    append(Begin,["_","b"|Tail],B).

move(A,B):-
    append(Begin,["_","b","w"|Tail],A),
    append(Begin,["w","b","_"|Tail],B).

move(A,B):-
    append(Begin,["b","w","_"|Tail],A),
    append(Begin,["_","w","b"|Tail],B).

print_ans([]).
print_ans([H|Tail]):-
    print_ans(Tail),
    write(H), nl.

dfs(Goal,[Goal|Tail]) :-
        !, print_ans([Goal|Tail]).
       
dfs(Goal, [Curr|Tail]) :-
    move(Curr, Tmp),
    not(member(Tmp,Tail)),
    dfs(Goal, [Tmp, Curr|Tail]). 

next(X, HasBeen, Y) :-
    move(X,Y),
    not(member(Y,HasBeen)). 

bfs([First|_],Goal,First) :- 
    First = [Goal|_].
bfs([[LastWay|HasBeen]|OtherWays],Finish,Way):-  
    findall([Z,LastWay|HasBeen],
            next(LastWay, HasBeen, Z), List),
            append(List,OtherWays,NewWays), 
            bfs(NewWays,Finish,Way).
                  
prolong([X|T],[Y,X|T]) :-
    move(X,Y),
    not(member(Y,[X|T])). 

switer([Goal|Tail],Goal,[Goal|Tail],0).

switer(TempWay,Goal,Way,N):- 
    N > 0,
    prolong(TempWay,NewWay),
    N1 is N-1,
    switer(NewWay,Goal,Way,N1).

for(X, X, _).
for(I, X, Y):-
    X < Y,
    X1 is X + 1,
    for(I, X1 ,Y).

solve(Start, Goal):-
    write('SEARCH WITH ID START'), nl,
    get_time(SWI),
    for(Lvl, 1, 20),
    switer([Start], Goal, Way, Lvl),
    print_ans(Way),
    get_time(SWI1),
    write('SEARCH WITH ID END'), nl, nl,
    T is SWI1 - SWI,
    write('TIME IS '), write(T), nl, nl,
    
    write('SEARCH IN DEPTHS START'), nl,
    get_time(DFS),
    dfs(Goal, [Start]),
    get_time(DFS1),
    write('SEARCH IN DEPTHS END'), nl, nl,
    T1 is DFS1 - DFS,
    write('TIME IS '), write(T1), nl, nl,
    
    write('SEARCH IN BFS START'), nl,
    get_time(BFS),
    bfs([[Start]],Goal,Way), 
    print_ans(Way),
    get_time(BFS1),
    write('SEARCH IN BFS END'), nl, nl,
    T2 is BFS1 - BFS,
    write('TIME IS '), write(T2), nl, nl,
    !.