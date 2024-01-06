% info(<имя>, <номер высказывания>,<список студентов(студенты - списки)>)
info(g, 1, [Ge, Ol, Di]) :- member(history, Di), not(member(history, Ge)), not(member(history, Ol)). % Дима единственный из нас, кто любит историю.
info(g, 2, [Ge, Ol,_]) :- crossing_sets(Ge, Ol, L), length(L, 3). % Олег и я увлекаемся одними и теми же предметами.
info(g, 3, [Ge, Ol, Di]) :- member(biology, Ge), member(biology, Ol), member(biology, Di). % Мы все считаем биологию интереснейшей наукой
info(g, 4, [Ge, Ol, Di]) :- same_subject([Ge, Ol, Di]). % Двое из нас любят и химию, и биологию.

info(o, 1, [Ge, Ol, Di]) :- member(math, Ge), member(math, Ol), member(math, Di). % Нам всем очень нравится математика.
info(o, 2, [Ge,_,_]) :- member(history, Ge). % Герман завзятый историк.
info(o, 3, [_, Ol, Di]) :- subtraction(Ol, Di, L), length(L, 1). % В одном из увлечений мы расходимся с Димой.
info(o, 4, [Ge,_, Di]) :- member(chemistry, Ge), member(chemistry, Di). % Герман и Дима любят химию. 

info(d, 1, [Ge, Ol, Di]) :- crossing_sets(Ge, Ol, L1), crossing_sets(Di, L1, L2), length(L2, 1). %  Есть только один предмет, который любим мы все.
info(d, 2, [Ge, Ol, Di]) :- not(member(math, Ge)), not(member(math, Ol)), member(math, Di). % Математикой увлекаюсь я один.
info(d, 3, [Ge, Ol, Di]) :- crossing_sets(Ge, Ol, L1), crossing_sets(Ge, Di, L2), crossing_sets(Di, Ol, L3), % Каждый из нас любит разное сочетание дисциплин. 
                           length(L1, I1),length(L2, I2),length(L3, I3), I1 < 3, I2 < 3, I3 < 3. 
info(d, 4, [Ge,_, Di]) :- not(info(o, 4, [Ge,_, Di])). % Олег ошибается, говоря, что Герман и я увлекаемся химией.

% Когда увлекаются одними и теми же предметами(Биология, Химия)
same_subject([Ger, Oleg,_]) :- member(biology, Ger), member(chemistry, Ger), member(biology, Oleg), member(chemistry, Oleg).
same_subject([Ger,_, Dima]) :- member(biology, Ger), member(chemistry, Ger), member(biology, Dima), member(chemistry, Dima).
same_subject([_, Oleg, Dima]) :- member(biology, Dima), member(chemistry, Dima), member(biology, Oleg), member(chemistry, Oleg).

% Пересечение множеств на основе списков
crossing_sets([],_, []).
crossing_sets([H|T], Y, [H|R]) :- memb(H, Y), crossing_sets(T, Y, R), !.
crossing_sets([_|T], Y, R) :- crossing_sets(T, Y, R), !.

memb(_, []) :- fail.
memb(X, [X|_]) :- !.
memb(X, [_|T]) :- memb(X, T).

% Вычитание списка из списка
subtraction([], _, []) :- !.
subtraction([A|C], B, D) :- member(A, B), !, subtraction(C, B, D).
subtraction([A|B], C, [A|D]) :- subtraction(B, C, D).

elems([T1, T2, L1, L2], T1, T2, L1, L2). % Связываем значения [T1, T2, L1, L2] с остальными элементами списка для перебора

% Перебираем все возможные утверждения кого-то из студентов
check(Z, V) :-
        permutation([1, 2, 3, 4], P), elems(P, T1, T2, L1, L2),
        info(Z, T1, V), info(Z, T2, V), not(info(Z, L1, V)), not(info(Z, L2, V)). % Должны выполняться только два info, так как по условию только два высказывания верны

takethree([_|T], T) :- length(T, 3). % Возвращает последние 3 элемента списка
        
solve(Ger,Oleg,Dima) :-
        permutation([biology, chemistry, math, history], Ge),
        permutation([biology, chemistry, math, history], Ol),
        permutation([biology, chemistry, math, history], Di),
        takethree(Ge, Ger), takethree(Ol, Oleg), takethree(Di, Dima),
        check(g, [Ger, Oleg, Dima]), check(o, [Ger, Oleg, Dima]), check(d, [Ger, Oleg, Dima]), !. % Возвращаем первое найденное решение

