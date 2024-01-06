# Отчет по лабораторной работе №3
## по курсу "Логическое программирование"

## Решение задач методом поиска в пространстве состояний

### Студент: Сарайкин Н.С.
### Вариант: 21 (по списку)

## Результат проверки

| Преподаватель     | Дата         |  Оценка       |
|-------------------|--------------|---------------|
| Сошников Д.В. |              |               |
| Левинская М.А.|              |               |

> *Комментарии проверяющих (обратите внимание, что более подробные комментарии возможны непосредственно в репозитории по тексту программы)*


## Введение

Метод поиска в простанстве состояний подходит для задач, в которых дискретное число состояний системы, заданы условия начального и конечного состояния и условия перехода из одного состояния в другое. Таким образом эти задачи удобно решаются всеми тремя типами поиска: DFS, BFS и итерационный поиск (ID). Для всех этих видов поиска оказывается очень удобным язык Prolog. В нем мы можем легко задать состояние системы и интуитивно определить её правила перехода в другое состояние. За счет удобного перебора и бэктрекинга Prolog пректрасно подходит для этого типа задач.

## Вариант (N mod 8) + 1 = 6

## Задание

Вдоль доски расположено 8 лунок, в которых лежат 4 черных и 3 белых шара. Передвинуть черные шары на место белых, а белые - на место черных. Шар можно передвинуть в соседнюю с ним пустую лунку, либо в пустую лунку, находящуюся непосредственно за ближайшим шаром.При этом черные шары можно передвигать только вправо, а белые - только влево.

## Принцип решения

Для решение нужны 4 шага:
* Если пустая лунку и справа белый шар, то поменять местами;
* Если черный шар и справа пустая лунка, то поменять местами;
* Если пустая лунка, затем черный шар и правее белый шар, то меняем на последовательность белый-черный-пусто;
* Если черный шар, затем белый шар и правее пустая лунка, то меняем на последовательность пусто-белый-черный.


Логические шаги для решения задачи:
```prolog
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
```

Поиск в глубину:
```prolog
dfs(Goal,[Goal|Tail]) :-
        !, print_ans([Goal|Tail]). 
dfs(Goal, [Curr|Tail]) :-
    move(Curr, Tmp),
    not(member(Tmp,Tail)),
    dfs(Goal, [Tmp, Curr|Tail]).
```

Поиск в ширину:
```prolog
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
```

Поиск с итеративным погружением:
```prolog
prolong([X|T],[Y,X|T]) :-
    move(X,Y),
    not(member(Y,[X|T])). 

switer([Goal|Tail],Goal,[Goal|Tail],0).

switer(TempWay,Goal,Way,N):- 
    N > 0,
    prolong(TempWay,NewWay),
    N1 is N-1,
    switer(NewWay,Goal,Way,N1).
```

## Результаты
```prolog
?- solve(["b","b","b","b","_","w","w","w"],["w","w","w","_","b","b","b","b"]).
SEARCH WITH ID START
[b,b,b,b,_,w,w,w]
[b,b,b,b,w,_,w,w]
[b,b,b,_,w,b,w,w]
[b,b,_,b,w,b,w,w]
[b,b,w,b,_,b,w,w]
[b,b,w,b,w,b,_,w]
[b,b,w,b,w,b,w,_]
[b,b,w,b,w,_,w,b]
[b,b,w,_,w,b,w,b]
[b,_,w,b,w,b,w,b]
[_,b,w,b,w,b,w,b]
[w,b,_,b,w,b,w,b]
[w,b,w,b,_,b,w,b]
[w,b,w,b,w,b,_,b]
[w,b,w,b,w,_,b,b]
[w,b,w,_,w,b,b,b]
[w,_,w,b,w,b,b,b]
[w,w,_,b,w,b,b,b]
[w,w,w,b,_,b,b,b]
[w,w,w,_,b,b,b,b]
SEARCH WITH ID END

TIME IS 0.007901668548583984

SEARCH IN DFS START
[b,b,b,b,_,w,w,w]
[b,b,b,b,w,_,w,w]
[b,b,b,_,w,b,w,w]
[b,b,_,b,w,b,w,w]
[b,b,w,b,_,b,w,w]
[b,b,w,b,w,b,_,w]
[b,b,w,b,w,b,w,_]
[b,b,w,b,w,_,w,b]
[b,b,w,_,w,b,w,b]
[b,_,w,b,w,b,w,b]
[_,b,w,b,w,b,w,b]
[w,b,_,b,w,b,w,b]
[w,b,w,b,_,b,w,b]
[w,b,w,b,w,b,_,b]
[w,b,w,b,w,_,b,b]
[w,b,w,_,w,b,b,b]
[w,_,w,b,w,b,b,b]
[w,w,_,b,w,b,b,b]
[w,w,w,b,_,b,b,b]
[w,w,w,_,b,b,b,b]
SEARCH IN DFS END

TIME IS 0.000293731689453125

SEARCH IN BFS START
[b,b,b,b,_,w,w,w]
[b,b,b,b,w,_,w,w]
[b,b,b,_,w,b,w,w]
[b,b,_,b,w,b,w,w]
[b,b,w,b,_,b,w,w]
[b,b,w,b,w,b,_,w]
[b,b,w,b,w,b,w,_]
[b,b,w,b,w,_,w,b]
[b,b,w,_,w,b,w,b]
[b,_,w,b,w,b,w,b]
[_,b,w,b,w,b,w,b]
[w,b,_,b,w,b,w,b]
[w,b,w,b,_,b,w,b]
[w,b,w,b,w,b,_,b]
[w,b,w,b,w,_,b,b]
[w,b,w,_,w,b,b,b]
[w,_,w,b,w,b,b,b]
[w,w,_,b,w,b,b,b]
[w,w,w,b,_,b,b,b]
[w,w,w,_,b,b,b,b]
SEARCH IN BFS END

TIME IS 0.0006659030914306641

true.
```

## Выводы

В данной лабораторной работе мною были применены навыки на языке Prolog для решения задачи на поиск в пространстве состояний. Как оказалось, Prolog в данном случае весьма эффективный инструмент.
Были написаны три алгоритма поиска: DFS, BFS и с итеративным погружением(ID). Все три алгоритма справились со своей задачей, но наиболее эффективными, в моем случае, оказались DFS и BFS.