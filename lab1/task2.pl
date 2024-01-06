% представление two.pl, вариант с заданиями 3

:- set_prolog_flag(encoding, utf8).

:- ['two.pl'].

% 1) Для каждого студента, найти средний балл, и сдал ли он экзамены или нет
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
 passExams(Stud) :- % проверка сдачи экзаменов студентом (Если хотя бы одна двойка, то false)
   findall(Grade, grade(_, Stud, _, Grade), Grades),
   not(member(2, Grades)).

% 2) Для каждого предмета, найти количество не сдавших студентов.

%(Предмет, количество)
countOfFailed(Subj, N) :- 
   findall(Student, (grade(_, Student, Subj, Grade), Grade = 2), Students), 
   length_(Students, N).

% 3)Для каждой группы, найти студента (студентов) с максимальным средним баллом

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