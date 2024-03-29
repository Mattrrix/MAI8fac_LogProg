# Отчет по лабораторной работе №1
## Работа со списками и реляционным представлением данных
## по курсу "Логическое программирование"

### Студент: Сарайкин Н.С.
### Вариант: 21 (по списку)

## Результат проверки

| Преподаватель     | Дата         |  Оценка       |
|-------------------|--------------|---------------|
| Сошников Д.В. |              |               |
| Левинская М.А.|              |               |

> *Комментарии проверяющих (обратите внимание, что более подробные комментарии возможны непосредственно в репозитории по тексту программы)*


## Введение

Списки в языке Пролог отличаются от принятых в императивных языках подходов к хранению данных. В прологе любой список разделён на голову и хвост, причём хвост всегда представлен только одним элементом. Кроме того, они используются для представления структур данных, где каждый элемент списка может содержать какое-либо значение или список значений. Это отличается от императивных языков, где списки обычно представлены как последовательности элементов, индексированные числами и имеющие фиксированный размер. Списки в Прологе похожи на односвязные списки в традиционных языках программирования, таких как C или Java. Они представляются как цепочка ячеек памяти, где каждая ячейка содержит две части: значение элемента и указатель на следующую ячейку списка. Пролог также позволяет использовать пустой список, который не содержит элементов и обозначает конец списка.

## Задание 1.1: Предикат обработки списка

### Стандартные предикаты для работы со списками:

```prolog
length_([], 0). % предикат получения длины списка
length_([_|Y], N) :- length_(Y,N1), N is N1 + 1.

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
```

### Примеры использования:

```prolog
?- length([q,w,e],N).  
N = 3
?- member(X,[a,b,c]).  
X = a ;
X = b ;
X = c;
false
?- append([a],[b,c],L). 
L = [a, b, c]
?- remove(c,[a,b,c],P).
P = [a, b]
?- permute([a,b,c],L). 
L = [a, b, c] ;
L = [a, c, b] ;
L = [b, a, c] ;
L = [b, c, a] ;
L = [c, a, b] ;
L = [c, b, a] ;
false.
?- sublist([1, 2], [1, 2, 3]). 
true
```

### Специальный предикат в соответствие с ((21 % 19) + 1) = 3 вариантом:
`remove_last_three(X1,X2)` - удаление трех последних элементов списка на стандартных предикатах.
`delete_last_three(X1,X2)` - удаление трех последних элементов списка без использования стандартных предикатов.

### Примеры использования:

```prolog
?- remove_last_three([1,12,3,156,41,1,2,3],X).
X = [1, 12, 3, 156, 41].
?- delete_last_three([3,2,0],X).
X = [].
?- remove_last_three([1, 2, 3, 4, 5], X).
Result = [1, 2].
?- delete_last_three([a, b, c, d], X).
Result = [a].
```

### Реализация на стандартных предикатах обработки списков:

```prolog
remove_last_three(List, Result) :- length(List, L), L >= 3, append(Result, [_,_,_], List).
remove_last_three(List, Result) :- length(List, L), L < 3, Result = [].
```

### Реализация без использования стандартных предикатов обработки списков:

```prolog
delete_last_three([], []).
delete_last_three([_], []).
delete_last_three([_, _], []).
delete_last_three([_, _, _], []).
delete_last_three([H|T], [H|Result]) :- delete_last_three(T, Result). 
```

`remove_last_three(X1,X2)` работает на основе рекурсии. Если список содержит меньше 4 элементов, то возвращаем пустой список `[]`.(базовый случай). В рекурсивном случае "откусываем голову" и рекурсивно вызываем предикат для оставшейся части списка до тех пор, пока не достигнем базового случая.
В случае использования `delete_last_three(X1,X2)` у нас есть 2 правила: Если длина списка `L` больше или равна 3, то используем предикат `append(Result, [_,_,_], List)`. Этот предикат добавляет в конец хвоста `Result` три метаперменных, чтобы удалить последние три элемента из списка `List`. В обратном случае возвращаем пустой список `[]`.


## Задание 1.2: Предикат обработки числового списка

### Специальный предикат в соответствие с ((21+5) mod 20 + 1) = 7 вариантом:

`ascending([X|Y])` - Проверка упорядоченности элементов по возрастанию на стандартных предикатах.
`ordered([X|Y])`- Проверка упорядоченности элементов по возрастанию без использования стандартных предикатов.

### Примеры использования:

```prolog
?- ordered([1, 2, 3]).
true.

?- ascending([3, 2, 1]).
false.

?- ordered([1, 2, 2, 3, 4, 4, 4, 5]).
true.

?- ascending([1, 2, 2, 3, 4, 3, 4, 5]).
false.
```
### Реализация на стандартных предикатах обработки списков:

```prolog
ordered([]).
ordered([_]).
ordered(L) :- length(L, N), N > 1, not((append(_, [X, Y | _], L), X > Y)).
```

### Реализация без использования стандартных предикатов обработки списков:
```prolog
ascending([]). % пустой список считается упорядоченным по возрастанию
ascending([_]). % список с одним элементом также считается упорядоченным

ascending([X,Y|T]) :- X =< Y, ascending([Y|T]).
```
`ascending([X|Y])` проверяет, является ли список упорядоченным по возрастанию. Если список пустой или содержит только один элемент, то он считается упорядоченным по возрастанию. Если список содержит более одного элемента, то мы сравниваем первый элемент с вторым. Если первый элемент меньше или равен второму, то мы проверяем оставшуюся часть списка, используя рекурсию. Если же это условие не выполняется, то список не является упорядоченным по возрастанию.
`ordered([X|Y])` проверяет то же самое. Разберем последнюю строчку. `append(_, [X, Y | _], L)` разбивает список `L` таким образом, чтобы мы смогли сравнить первый и второй элементы списка между собой. `not((append(_, [X, Y | _], L), X > Y))` проверяет, что не существует такого разбиения списка, где первый элемент больше второго элемента.

####Пример совместного использования предикатов (`length`, `member`, `permute`, `sublist`, `delete_last_three`):
  Допустим, у нас есть список чисел [1, 2, 3, 4, 5, 6, 7]. Мы хотим найти все перестановки этого списка, в которых удалены последние 3 элемента и которые содержат подсписок  [5,6]. Для этого нам явно придется использовать предикаты `delete_last_three`, `permute`, `sublist` (или `member`). Кроме того, логично, что такие перестановки должны состоять из 4 элементов. Поэтому мы можем добавить проверку длины с помощью предиката `length`.


## Задание 2: Реляционное представление данных

### Вариант 3
#### Вариант заданий ((21-1) mod 3)+1 = 3 
    - Для каждого студента, найти средний балл, и сдал ли он экзамены или нет
    - Для каждого предмета, найти количество не сдавших студентов
    - Для каждой группы, найти студента (студентов) с максимальным средним баллом

Реляционное программирование основано на описании отношений между аргументами и результатом. Здесь важно создавать программы, которые могут анализировать эти отношения. Одними из главных преимуществ реляционного подхода являются простота использования, теоретическое обоснование и независимость данных. Однако его недостатком является низкая скорость выполнения операций соединения.

###Преимущества и недостатки использованного реляционного представления данных `two.pl`
#### Вариант представления данных о студентах (21 mod 4)+1 = 2

Преимущества:
- Структурированное представление данных с помощью предикатов позволяет легко организовывать информацию и выполнять операции с ней.
- Возможность использования запросов на выборку данных для получения нужной информации.
- Простой и понятный синтаксис предикатов, что облегчает чтение и понимание кода.

Недостатки:
- Большой объем данных, занимающий много места и усложняющий обработку данных.
- Отсутствие типов данных и проверки их правильности может привести к потенциальным ошибкам и некорректным результатам.
- Необходимость вручную написать все предикаты для обработки данных. (может быть крайне трудоемкой задачей)

#### Задание 2.1: Для каждого студента, найти средний балл, и сдал ли он экзамены или нет.

`averageMark(Stud, Mark)` - предикат, находящий средний балл студента. 
`passExams(Stud)` - предикат, проверяющий сдал ли студент экзамен.

#### Реализация:

```prolog
sumList([], 0). % сумма всех элементов в списке
sumList([X|Xs], Sum) :- sumList(Xs, Rest), Sum is X + Rest.

length_([], 0). % предикат получения длины списка
length_([_|Y], N) :- length_(Y,N1), N is N1 + 1.

member(A, [A|_]). % предикат проверки вхождения элемента в список 
member(A, [_|Z]) :- member(A,Z).

%(Студент, Средняя оценка)
averageMark(Stud, Mark) :- % средний балл студента
    findall(Grade, grade(_, Stud, _, Grade), Grades),
    length_(Grades, N),
    sumList(Grades, Sum),
    Mark is Sum / N.

%(Студент)
 passExams(Stud) :- % предикат проверки сдачи экзаменов студентом (Если хотя бы одна двойка, то false)
   findall(Grade, grade(_, Stud, _, Grade), Grades),
   not(member(2, Grades)).
```

Для поиска средней оценки находятся все оценки студента, помещаются в список `Grades`, суммируются через `SumList` и cумма делится на их количество. Для выяснения сдал ли студент все экзамены, ищутся все его оценки и проверятся нет ли у него хотя бы одной двойки.

#### Примеры использования:
```prolog
?- averageMark('Запорожцев', X).
X = 4.

?- averageMark('Вебсервисов',X).
X = 4.333333333333333.

?- passExams('Петров').
false.

?- passExams('Азурин').
true.
```

#### Задание 2.2: Для каждого предмета, найти количество не сдавших студентов.

`countOfFailed(Subj, N)` - предикат, находящий количество не сдавших студентов соответствующего предмета.

#### Реализация:

```prolog
%(Предмет, количество)
countOfFailed(Subj, N) :- 
   findall(Student, (grade(_, Student, Subj, Grade), Grade = 2), Students), 
   length_(Students, N).
```
#### Примеры использования:
```prolog
?- countOfFailed('Математический анализ',X).
X = 3.

?- countOfFailed('Психология', X).
X = 1.

?- countOfFailed('Информатика', X).
X = 2.
```
Сбор и поиск студентов, получивших оценку '2' осуществляем через `findall`. Искомые студенты помещаются в список `Students`. С помощью `length` находим количество таких студентов.

#### Задание 2.3: Для каждой группы, найти студента (студентов) с максимальным средним баллом.

`bestStudent(Group,N)` - предикат, выводящий список, состоящий из студентов с максимальным средним баллом по группе.

#### Реализация:

```prolog
%(Список из чисел, максимальный элемент из списка)
max_list_([X], X). % предикат, который находит максимальный элемент в списке чисел
max_list_([H|T], Max) :- 
    max_list_(T, MaxTail), 
    H >= MaxTail, 
    Max is H.
max_list_([H|T], Max) :- 
    max_list(T, MaxTail), 
    H < MaxTail, 
    Max is MaxTail.

%(Группа, количество студентов)
bestStudent(Group, N) :-
    findall(Mark, (grade(Group, Stud, _,_), averageMark(Stud,Mark)), Marks), % собираем список со всеми средними оценками
    max_list_(Marks, Max), % находим максимальную из них
    M is Max,
    setof(A,(grade(Group,A,_,_), averageMark(A,M)),N), !. % составляем список (без повторений!) из всех студентов имеющих такую оценку
```
#### Примеры использования:

```prolog
?- bestStudent(103, Student).
Student = ['Вебсервисов', 'Клавиатурникова', 'Программиро'].

?- bestStudent(102, Student).
Student = ['Текстописов'].

?- bestStudent(101, Student).
Student = ['Густобуквенникова'].
```
Сначала собираем список со всеми средними оценками по искомой группе с помощью `findall`,`averageMark`. Далее используем `max_list_`, чтобы найти максимальную среднюю оценку по списку. Наконец, составляем список (без повторений фамилий) из всех студентов, соответствующих максимальной средней оценке.

## Выводы

В процессе выполнения данной лабораторной работы, я ознакомился с концепцией декларативного программироавния, в частности с языком программирования Prolog, с тем, как здесь устроены списки, с принципом работы различных предикатов и с написанием самих предикатов для выполнения разнообразных задач. Мой главный вывод, вытекающий из вышеизученного, заключается в том, что в логическом программировании ключевым является понимание того, каким должен быть результат задачи, а не процесс его достижения, как это обычно бывает в императивном программировании. В результате выполнения этой работы я увидел, что средства логического программирования могут быть эффективными при работе с реляционными представлениями данных.




