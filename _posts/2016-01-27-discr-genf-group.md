---
layout: post
title:  "Производящие функции и лемма Бёрнсайда. Теорема Редфилда–Пойа."
lang: ru
tags:
    teaching
    generating_functions
    group_theory
---

* Музыка: [Joe Pass –  How High The Moon](https://music.yandex.ru/album/59513/track/555209).

## С чего всё началось

В этом семестре я вёл у первокурсников занятия по дискретной математике. Папку с материалами семинаров можно найти в [гугл-диске](https://drive.google.com/open?id=0B733JIZxEnkNRFhQdW5Nak5FRUU). 

<!-- К третьему семестру сложилась примерно такая система:

* На семинарах я старался выдавать листочки со списком задач, которые мы собираемся разобрать
* Время от времени в начале или в конце семинара проводилась 15-минутная мини-контрольная. Она была необязательной, и максимальную оценку можно получить, не участвуя в мини-контрольных, но хорошее решение давало некоторый бонус к оценке.
* В среднем раз в две недели появлялось новое домашнее <s>вино</s> задание. В него входил конспект по прошедшим 
занятиям, чтобы проще было решать задачи.
* Стартовая оценка, в основном, состояла из больших контрольных, которые мы писали на семинарах, домашних заданий. На зачёте можно было её повысить, решая задачки.

В этом семестре я довольно много внимания уделил производящим функциям.
-->
Производящие функции – это мощный комбинаторный инструмент, который позволяет превратить комбинаторно сформулированную задачу на подсчёт объектов в проблему нахождения некоторого степенного ряда.

## Производящие функции

Следующая задача про фрукты и овощи имеет чисто комбинаторное решение, но также хорошо иллюстрирует идею того, как можно превращать комбинаторные конструкции в степенные ряды.

>Задача. 
>
>На рынке нужно купить не более четырёх апельсинов, кратное пяти 
количество бананов, чётное число вишен и не более одного граната. 
Сколькими способами можно набрать корзину из  \\( \, n \\) фруктов?

### Решение

Рассмотрим четыре функции
\begin{align}
    \text{А}(x) & = 1 + x + x^2 + x^3 + x^4 &= \dfrac{1 - x^5}{1 - x} \\\
    \text{Б}(x) & = 1 + x^5 + x^{10} + \ldots & = \dfrac{1}{1 - x^5} \\\
    \text{В}(x) & = 1 + x^2 + x^4 + \ldots &= \dfrac{1}{1 - x^2} \\\ 
    \text{Г}(x) & = 1 + x &
\end{align}

Заметим, что коэффициент при \\( x^n \\) в произведении этих формальных 
степенных рядов равен количеству способов набрать корзину из \\( n \\) 
фруктов. И действительно, при раскрытии произведения из четырёх скобок 
$$    
(1 + x + x^2 + x^3 + x^4 )
(1 + x^5 + x^{10} + \ldots )
(1 + x^2 + x^4 + \ldots  )
(1 + x)
$$
необходимо из каждой скобки выбрать по одному сомножителю, каждый 
сомножитель имеет вид \\( x^k \\). Посмотрим на показатель степени: 
сомножитель из первой скобки соответствует числу апельсинов (их не больше 
четырёх), из второй скобки – числу бананов (их количество кратно пяти), и 
так далее. При перемножении показатели степеней складываются. Если 
получилось число \\( n \\), то мы смогли набрать ровно \\( n \\) фруктов.

Значит, коэффициент при \\( x^n \\) равен количеству способов набрать 
корзину, как и утверждалось. Теперь преобразуем данное произведение:
\\[
    \text{А}(x) \cdot \text{Б}(x) \cdot  \text{В}(x) \cdot  \text{Г}(x)=
    \dfrac{1 - x^5}{1 - x} \cdot \dfrac{1}{1 - x^5} \cdot \dfrac{1}{1 - 
    x^2} \cdot (1 + x) = \dfrac{1}{(1 - x)^2}
\\]
Заметим, что функция \\( \dfrac{1}{(1 - x)^2} \\) является производной от 
функции \\( \dfrac{1}{1 - x} \\), которая равна \\( 1 + x + x^2 + \ldots \\) 

Значит,
\\(
    \dfrac{1}{(1 - x)^2} = 1 + 2x + 3x^2 + \ldots,
\\)
и коэффициент при \\( x^n \\) равен \\( n+1. \\)

### Немного о технике производящих функций

>Определение.  
>
>Если задано некоторое (возможно, бесконечное) множество \\( A\\), и каждый элемент \\( a \in A \\) имеет целый неотрицательный *размер* \\( |a| \\), то этому множеству (при разумных ограничениях) можно сопоставить формальный степенной ряд:
\\[
    A(x) = \sum\_{a \in A} x^{|a|}
\\]
>Для того, чтобы эта производящая функция была корректно определена как степенной ряд, необходимо и достаточно, чтобы элементов каждого размера было конечное количество, то есть чтобы коэффициенты были конечными.

В этом примере мы определили "элементарные" производящие функции как составные части корзины: отдельную производящую функцию для каждого вида фруктов, можете проверить, что выражения, написанные выше, в точности следуют определению.

Затем мы перемножили эти производящие функции. При перемножении производящих функций мы получаем производящую функцию для декартова произведения, то есть для кортежей длины четыре, в которых на первом месте стоят апельсины, на втором бананы, на третьем вишни и на четвёртом гранаты. Вся "магия", которая позволяла нам преобразовывать это произведение, абсолютно легально, и доказывается с помощью нескольких несложных лемм.
                                                                 
## Лемма Бёрнсайда и раскраска ожерелий

Это утверждение тоже рассказывают в курсе дискретного анализа, но во втором семестре. Оно очень хорошо иллюстрируется следующей задачей.
  
>Задача.
>
>Сколькими способами можно раскрасить ожерелье из \\( n \\) бусин в \\( k \\) цветов, при условии, что ожерелье можно поворачивать? Раскраски, которые можно совместить поворотом, считаются одинаковыми.

### Решение

Чтобы найти количество раскрасок, нужно изучить группу поворотов ожерелья. Всего имеется \\( n \\) поворотов. Для каждого поворота можно перечислить и найти количество раскрасок, которые остаются неподвижными при данном повороте. Например, при тождественном повороте все раскраски переходят в себя. Если, например, в ожерелье чётное число бусин, и мы поворачиваем ожерелье на 180 градусов, то количество неподвижных раскрасок будет \\( 2^{n/2},\\) потому что вся покраска определяется половиной бусин.

> Лемма (Бёрнсайд)
>
> Пусть группа \\( G \\) действует на множестве \\( X\\), и при этом для каждого элемента \\( g \in G \\) множество неподвижных элементов, то есть таких, что \\( gx = x \\), обозначим \\( X^g \\).
> Тогда число орбит действия группы \\( G \\) на множестве \\( X \\) равно
> \\[
>   \omega = \dfrac{\sum\_{g \in G} |X^g|}{|G|}
> \\] 

С точки зрения нашей задачи, нужно для каждого поворота, скажем, на \\( j \\) позиций, найти количество раскрасок, которые перейдут в себя, это и будет равно \\( \|X^g\| \\). Несколько слов о том, почему количество неподвижных элементов перестановки обозначается \\( X^g \\). Пусть мы, например, решаем задачу о покраске вершин куба. В кубе всего шесть вершин, и если мы повторяем действие некоторой перестановки снова и снова (например, поворот вокруг главной диагонали на 120  градусов), то вершины распадаются на циклы. Тогда если мы красим куб в \\( k \\) цветов, то количество неподвижных точек этой перестановки будет равно \\( k^c \\), где \\( c \\) – количество циклов. В итоге произошла подмена понятий: под множеством \\( X \\) в основании степени подразумевается число цветов покраски, а под \\( g\\) в показателе степени подразумевается число циклов, которое порождает эта перестановка.
                            
Сказано – сделано, нетрудный подсчёт показывает, что при повороте на \\( j \\) позиций ожерелье распадается на \\( \text{НОД}(n,j) \\) различных одноцветных ожерелий, причём каждое ожерелье может быть покрашено в любой цвет независимо от других. Напомню, что количество цветов для покраски равно \\( k\\). Значит, количество раскрасок равно
$$
    \omega = \dfrac{\sum_{j=1}^n k^{(j,n)} }{n}
$$
Эта формула даёт нам правильный ответ, можно на этом остановиться. Но можно заметить, что некоторые слагаемые можно сгруппировать между собой, потому что НОД чисел \\( j, n \\) иногда получается одинаковым для разных \\( j \\). Коэффициенты для группировки слагаемых даёт нам [Функция Эйлера](https://ru.wikipedia.org/wiki/Функция_Эйлера) (количество чисел, не превышающих \\( n \\) и взаимно простых с \\( n \\) равно \\( \varphi(n) \\)):

$$
    \omega = \frac{\sum_{d \mid n} \varphi(n/d) k^d }{n}
$$

#### Доказательство леммы Бёрнсайда для ожерелий

Для начала будем считать, что ожерелье представляет собой строку из \\( n \\) символов, а ожерелья, которые можно совместить поворотом, мы считаем эквивалентными. Найдём количество пар (ожерелье; поворот), таких, что поворот сохраняет ожерелье на месте.

С одной стороны, если рассмотреть каждый поворот \\( g \\) в отдельности, то количество ожерелий, которое он оставляет на месте, это по определению, \\( \|X^g\| \\). Поэтому количество пар равно \\( \sum\_{g \in G} \|X^g\| \\).

С другой стороны, внимательно представим себе разбиение всех ожерелий на классы эквивалентности. Очевидно, размер каждого класса эквивалентности не больше, чем \\( n \\), потому что каждое ожерелье можно в принципе повернуть не более, чем \\( n \\) способами. Каждое ожерелье из этого класса эквивалентности можно с помощью некоторых поворотов перевести в себя (по крайней мере с помощью тождественного).

> Утверждение.
>
> Размер каждого класса эквивалентности, а также количество поворотов, которое оставляет любое ожерелье на месте, являются делителями числа \\( n \\). Более того, произведение этих чисел для одного класса эквивалентности даёт в точности число \\( n. \\)

Это несложное утверждение остаётся в качестве упражнения. Из него, в частности следует, что количество пар ожерелье-поворот в пределах каждого класса эквивалентности равно \\( n \\), а всего их \\( \omega \cdot n \\). Лемма Бёрнсайда доказана.

## Какая здесь связь?

Над комбинаторными множествами можно производить разные операции, которые отражаются в их производящих функциях. Три стандартные операции:

* Объединение: \\( F_{A \cup B} (x) = F\_{A} (x) + F\_{B}(x) \\).
* Декартово произведение: \\( F\_{A \times B} (x) = F\_A(x) \cdot F\_B(x) \\).
* Последовательности элементов из \\( A \\): \\(  F\_{\mathrm{SEQ}(A)}(x) = 1 + A(x) + A(x)^2 + \ldots = \dfrac{1}{1 - A(x)} \\).

Есть и другие операции, с более сложными выражениями для соответствующих производящих функций. В эти формулы входят интегралы, производные, бесконечные произведения. Но тем не менее, для многих комбинаторных конструкций существуют выражения, использующие элементарные алгебраические операции и не "залезающие" вовнутрь коэффициентов составных частей.

На зачёте с моими студентами мы обсуждали одну теорему из книги Флажоле ["Analytic Combinatorics"](http://algo.inria.fr/flajolet/Publications/book.pdf). В ней предлагается рассмотреть множество **циклов**, чьи элементы являются элементами множества \\( A \\) (не обязательно различными), своего рода ожерелья, но вместо различных цветов будут различные элементы множества \\( A\\).

> Теорема.
>
> Если \\( B = \mathrm{CYC}(A) \\), то для соответствующей производящей функции выполнено
> $$
>   B(z) = \sum_{k=1}^{\infty} \dfrac{\varphi(k)}{k} \log\dfrac{1}{1 - A(z^k)}
> $$

Так как в это утверждение входят ожерелья и функция Эйлера, то на первый взгляд кажется, что у этого утверждение должно быть естественное комбинаторное доказательство, ведь логарифм имеет осязаемое разложение в ряд Тейлора
$$
    \log\dfrac{1}{1 - F(x)} = F(x) + \dfrac{F^2(x)}{2} + \dfrac{F^3(x)}{3} + \ldots
$$
Авторы книги предлагают красивое доказательство в духе ТФКП и теории вычетов. Мы же после нескольких попыток смогли придумать комбинаторное доказательство для этого факта. Более того, в частном случае с ожерельями несложно придумать чисто комбинаторное доказательство леммы Бёрнсайда, не прибегая к терминологии теории групп.

### Комбинаторное доказательство
Для начала, преобразуем уже известную нам функцию \\( B(z) \\):
\begin{align}
    \sum\_{k=1}^\infty \dfrac{\varphi(k)}{k} \log \dfrac{1}{1 - B(z^k)}
   &=  \sum\_{k=1}^\infty \dfrac{\varphi(k)}{k} \sum\_{j=1}^\infty \dfrac{B(z^k)^j}{j} \\\
   &=  \sum\_{k=1}^\infty \sum\_{j=1}^\infty \dfrac{\varphi(k)}{kj} B(z^k)^j \\\                 
   &=  \sum\_{j=1}^\infty \sum\_{k=1}^\infty \dfrac{\varphi(k)}{kj} B(z^k)^j \\\                                       
   &=  \sum\_{kj=1}^\infty \sum\_{k | kj} \dfrac{\varphi(k)}{kj} B(z^k)^{kj/k} \\\
   &=  \sum\_{m=1}^\infty \sum_{d | m} \dfrac{\varphi(d)}{m} B(z^d)^{m/d}                                    
\end{align}

Заметим, что в таком виде формула уже очень похожа на формулу с ожерельями. Здесь выражение \\( B(z^d) \\) играет роль "цветов", \\( m \\) это размер ожерелья, или количество различных поворотов. При этом пока непонятно, почему вместо \\( B(z) \\) используется \\( B(z^d) \\), но мы это поймём чуть позже: ожерелья распадаются на \\( m/d \\) одинаковых ожерелий, содержащих \\( d \\) бусин, значит, внутри производящей функции \\( B(z) \\) нам понадобится сделать подстановку \\( z^d \\). Но обо всём по порядку.

Покажем, что каждое отдельное слагаемое в этой сумме \\( \sum\_{d | m} \dfrac{\varphi(d)}{m} B(z^d)^{m/d} \\)  соответствует циклу из \\( m \\) элементов. Для этого продолжим преобразовывать полученное слагаемое в духе леммы Бёрнсайда:
\\[
    \sum\_{d | m} \dfrac{\varphi(d) B(z^d)^{m/d}}{m} = \sum\_{k=1}^m \dfrac{1}{m} B(z^{(m,k)})^{m/(m,k)}
\\]
Заметим, что \\( B(t)^\ell \\) это декартово произведение \\( B(t) \\) на себя \\( \ell \\) раз. Осталось понять во-первых, почему нужно разделить на \\( m \\), а во-вторых, подставить вместо \\( t \\) \\( z^d \\).

Здесь \\( (m,k) \\) это длина цикла, а \\( m / (m,k) \\) – это количество циклов. Когда мы рассматриваем поворот на \\(k \\) позиций, то для неподвижных ожерелий нужно скопировать элемент из \\( B \\) сам себя \\( (m,k) \\) раз (это один цикл), и дальше склеить \\( m/ (m,k) \\) циклов, с возможно разными элементами. Я не буду описывать очень подробно окончание доказательства, манипуляции с формулами и аналогии с леммой Бёрнсайда позволяют завершить доказательство.

## [Теорема Редфилда–Пойа](https://en.wikipedia.org/wiki/Pólya_enumeration_theorem)
                                                                                        
Оказывается, в общем виде связь действия группы на множество и производящих функций хорошо изучена. Вместо операции \\( \mathrm{CYC}(A) \\) можно брать произвольную операцию, которую можно задать с помощью действия группы на множестве. Если говорить более аккуратно, то в случае циклов теорема Пойя применима лишь для \\( \mathrm{CYC}_m (A) \\), то есть лишь для циклов, для которых число элементов зафиксировано. Суммирование по всем циклам – технический приём и находится вне компетенции теоремы Редфилда-Пойя.

Пусть множество \\( A \\) имеет производящую функцию с конечными коэффициентами:
\\[
    A(z) = a\_0 + a\_1 z + a\_2 z^2 + \ldots
\\]
Пусть задана некоторая группа перестановок \\( G \\) размера \\( n \\), при этом \\(G \\) действует на множестве \\(X\\). Каждая перестановка \\( g \in G \\) порождает разбиение объекта на циклы, и количество циклов длины \\(k \\) мы обозначим за \\( c\_k(g) \\). Ясно, что циклов длины больше, чем \\( n \\), возникнуть не может, а это количество достигается только в случае циклической группы.  Рассмотрим ещё одну функцию от \\( n \\) переменных, которая называется *цикловым индексом*:
\\[
    Z\_G(t\_1, t\_2, \ldots, t\_n) = \dfrac{1}{|G|}\sum\_{g \in G} t\_1^{c\_1(g)} t\_2^{c\_2(g)} \ldots t\_n^{c\_n(g)}
\\]
Мы будем рассматривать считать, что каждый элемент множества \\( X \\) заменяется на некоторый элемент множества \\( A\\), и при этом вес всего множества определяется как сумма весов входящих в него элементов. Это мы будем называть "раскраской". Некоторые раскраски, как обычно, эквивалентны, если их можно перевести друг в друга какой-нибудь перестановкой. Пусть количество раскрасок веса \\( w \\), то есть количество классов эквивалентности, равняется \\( b\_w \\). Производящая функция для раскрасок имеет вид \\( B(z) = b\_0 + b\_1 z + b\_2 z^2 + \ldots \\).

> Теорема Редфилда–Пойа
>
> Производящая функция для количества раскрасок с учётом весов равна
> \\[
>     B(z) = Z_G(A(z), A(z^2), \ldots, A(z^n))
> \\]

Доказательство общего случая, в том числе для производящих функций от многих переменных, можно найти [в википедии](https://en.wikipedia.org/wiki/Pólya_enumeration_theorem#Proof_of_theorem).

## Несколько слов о применении

На самом деле, почти все графы, которые мы хотим исследовать методом символической комбинаторики и производящих функций, будут содержать циклы, поэтому для описания таких конструкций так или иначе понадобится оператор \\( \mathrm{CYC} \\). Кроме того, семейство отображений из конечного множества в себя, например, является ориентированным графом, у которого исходящая степень каждой вершины равна единице. Такой граф является объединением циклов, к каждой вершине которого навешано дерево (возможно, пустое). Конечно, описанная выше конструкция уже относится к *помеченным* конструкциям, для которых нужны экспоненциальные производящие функции, но это всё взаимосвязано.

В своё время Бёрнсайд популяризовал свою лемму, когда предъявил много приложений, в том числе и в химии. Ссылки на его статьи можно найти в книге Филлипа Флажоле и Роберта Седжвика (стр. 84-87) [Analytic Combinatorics](http://algo.inria.fr/flajolet/Publications/book.pdf).

<u><b>Упражнения</b></u>

1. Докажите вспомогательную лемму из доказательства леммы Бёрнсайда.
2. Придумайте комбинаторное доказательство задачи про фрукты.
3. Преобразуйте общее выражение из леммы Бёрнсайда в случае с ожерельями к выражению, содержащему функцию Эйлера.
4. Проверьте, что случай с ожерельями является частным случаем леммы Пойя-Редфилда.
5. Найдите явные формулы для производящих функций \\( \mathrm{CYC}\_2 (A) \\),   \\( \mathrm{CYC}\_3 (A) \\),  \\( \mathrm{CYC}\_4 (A) \\) для произвольного множества \\( A \\) с известной производящей функцией \\( A(z) \\).
6. Попробуйте применить теорему Редфилда–Пойя для нахождения производящей функции для конструкции \\( \mathrm{CUBE} (A) \\), где \\( \mathrm{CUBE} (A) \\) – это кубики, в каждой вершине которых стоит какой-то элемент множества \\( A \\).
7. В книге Флажоле, с. 85-86 есть некоторые соображения на тему теории Пойя. А именно, предлагается ещё несколько любопытных конструкций, на которые можно посмотреть с точки зрения действия группы на множестве.
    * \\( \mathrm{SET}\_m(A) \\) – набор множеств, составленных из \\( m \\) элементов \\( A \\). Так как множество это множество, то в нём все элементы должны быть различными.
    * \\( \mathrm{MSET}\_m(A) \\) – набор мультимножеств, которые содержат \\(m \\) элементов из \\( A. \\) В мультимножестве элементы могут повторяться.  
    * \\( B = \mathrm{USEQ}(A)\\) – неориентированные последовательности, составленные из элементов \\( A.\\) Здесь мы отождествляем последовательности, прочитанные слева-направо и справа-налево.
\\[
    B(z) = \dfrac12 \dfrac{1}{1 - B(z)} + \dfrac12 \dfrac{1 + B(z)} {1 - B(z^2)} 
\\]
    * Аналогично можно определить \\( B = \mathrm{UCYC}(A) \\) – неориентированные циклы, где мы отождествляем не только ожерелья, полученные друг из друга поворотом, но и их зеркальные отражения.