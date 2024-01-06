% Стандартные предикаты

mylen([],0).   % Длина списка
mylen([_|Y],N) :- mylen(Y,N1), N is N1+1.

member(A, [A|_]). % предикат проверки вхождения элемента в список 
member(A, [_|Z]) :- member(A,Z).

append([],X,X). % предикат объединения списков
append([A|X],Y, [A|Z]) :- append(X,Y,Z).

remove(X,[X|T],T). % предикат удаления элемента из списка
remove(X,[Y|T],[Y|T1]) :- remove(X,T,T1).

permute([],[]). % предикат проверки перестановки списка
permute(L,[X|T]) :- remove(X,L,R), permute(R,T).

sub_start([], _List). % предикат проверки подсписка
sub_start([H|TSub], [H|TList]) :- sub_start(TSub, TList).
sublist(Sub, List) :- sub_start(Sub, List), !.
sublist(Sub, [_H|T]) :- sublist(Sub, T).

/* Tests:
?- length([q,w,e],N).  (N=3)
?- member(X,[a,b,c]).  (X=a,X=b,X=c)
?- append([a],[b,c],L). (L = [a, b, c])
?- remove(c,[a,b,c],P). (P = [a, b])
?- permute([a,b,c],L). (L = [a, b, c] ; L = [a, c, b] ; L = [b, a, c] ; L = [b, c, a] ; L = [c, a, b] ; L = [c, b, a] ;)
?- sublist([1, 2], [1, 2, 3]). (true)
*/

% Task 1.1 Удаление трех последних элементов списка.
% Удаление трех последних элементов списка (с использованием стандартных предикатов)

remove_last_three(List, Result) :- length(List, L), L >= 3, append(Result, [_,_,_], List).
remove_last_three(List, Result) :- length(List, L), L < 3, Result = [].

% Удаление трех последних элементов (без использования стандартных предикатов)

delete_last_three([], []).
delete_last_three([_], []).
delete_last_three([_, _], []).
delete_last_three([_, _, _], []).
delete_last_three([H|T], [H|Result]) :- delete_last_three(T, Result). 

% Task 1.2
% Проверка упорядоченности элементов по возрастанию (с использованием стандартных предикатов)

ascending([]). % пустой список считается упорядоченным по возрастанию
ascending([_]). % список с одним элементом также считается упорядоченным

ascending([X,Y|T]) :- X =< Y, ascending([Y|T]). 

% Проверка упорядоченности элементов по возрастанию (без использования стандартных предикатов)

ordered([]).
ordered([_]).
ordered(L) :- length(L, N), N > 1, not((append(_, [X, Y | _], L), X > Y)).


