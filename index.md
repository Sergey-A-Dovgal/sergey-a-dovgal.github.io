---
layout: page
title: Sergey Dovgal
ref: about
lang: en
---


My current affiliation is *attaché temporaire d'enseignement et de recherche* (one-year postdoc with 192h [teaching duty](teaching.html))
in **Université Sorbonne Paris Nord**, *Laboratoire d'Informatique de Paris Nord*,
former Université Paris 13.

<p align="center">
<img src="pic/up13.jpg" height=250vh
alt = "Université Sorbonne Paris Nord" />
<img src="pic/visage.jpg" height=250vh
alt = "A relatively recent photo" />
</p>

<!--I have defended my PhD thesis entitled "[An interdisciplinary image of Analytic
Combinatorics](https://lipn.fr/~dovgal/thesis.pdf)" on 18-th of September 2019
under the supervision of **Olivier Bodini** and **Vlady Ravelomanana**.-->

## Research overview

Since 2016, I am doing [research](research.html) in the field of **Analytic
Combinatorics**.
In short, Analytic Combinatorics studies [generating
functions](https://en.wikipedia.org/wiki/Generating_function) from the
perspective of [complex
analysis](https://en.wikipedia.org/wiki/Complex_analysis).

<p align="center">
<img src="pic/directed-graphs/product.svg"
alt = "arrow product symbolic construction for directed graphs" />
</p>
\\[
C(z) = 
    \sum_{n = 0}^\infty c_n 2^{-n(n-1)/2} \dfrac{z^n}{n!}
\\]
\\[
c\_n := \sum\_{k = 0}^n {n \choose k} a\_k b\_{n-k} 2^{k(n-k)}
\\]

A survey of my research (in Russian) for non-scientists is available
[[here]](https://www.youtube.com/watch?v=E4fvXP0ck_k)

### Two major applications of Analytic Combinatorics

[Generating
functions](https://en.wikipedia.org/wiki/Generating_function)
allow you to enter the world of simplistic perfection and
they demonstrate an innocent mathematical beauty.
But they are also a powerful tool when
it comes to studying large random objects.

**Enumeration** allows to tell you *how many* objects of a given size do there
exist, and in a more general form, allows to access distributions of
parameters of many systems.

**Random generation** allows to generate an object from a given class uniformly
at random. In somewhat more casual terms, it can be referred to as "Monte-Carlo
experiments" and you can find a
huge number of
[applications](https://en.wikipedia.org/wiki/Monte_Carlo_method#Applications) on the web.

### Phase transitions

The term “[phase transition](https://en.wikipedia.org/wiki/Phase_transition)”
was mostly used by physicists, but can be also
applied to many combinatorial situations, when a small change of a certain
parameter results in a huge asymptotic change of some other parameter. The
original studies of the physical phase transitions, including
[Ising](https://en.wikipedia.org/wiki/Ising_model) and
[Potts](https://en.wikipedia.org/wiki/Potts_model)
models, considered graphs which formed certain regular lattices: from rectangular
ones to more complicated including maps on surfaces. Of close relation is the
[percolation theory](https://en.wikipedia.org/wiki/Percolation_theory)
which is sometimes called “the simplest model displaying a
phase transition”. 

The phase transition phenomenon in random **simple graphs** and *multigraphs*
has been thoroughly studied.  One of the current goals of our research group is
to give an equally thorough description for a rapidly growing research body of
random **directed** graphs.

![Probability that all strongly connected components are
cycles](pic/directed-graphs/curve.png)

### Random generation

Sampling words uniformly at random from non-ambiguous
[context-free grammars](https://en.wikipedia.org/wiki/Context-free_grammar)
gives a solid basis for more advanced [applications](https://en.wikipedia.org/wiki/Monte_Carlo_method#Applications).
The principle of [Boltzmann
sampling](https://en.wikipedia.org/wiki/Boltzmann_sampler) can be most easily
illustrated using the example of Catalan binary trees, which are defined as
rooted binary trees. 
The method consists of taking the equation whose generation function
\\( T(z) = \sum\_{n \geq 0} T\_n z^n \\)
satisfies
\\[
    T(z) = z + z T^2(z),
\\]
fixing a positive value \\(z \in (0, 1/2) \\)
and making a Bernoulli choice \\( \Xi_z \\) such that
\\[
    \mathbb P( \Xi_z = 0)
    =
    \\dfrac{z}{z + z T^2(z)},
\\]
\\[
    \mathbb P( \Xi_z = 1)
    =
    \\dfrac{z T^2(z)}{z + z T^2(z)}.
\\]
If \\( \Xi\_z = 0 \\), the generation outputs a single node and stops, otherwise it recursively calls two Boltzmann samplers with a parameter \\( z \\) and outputs a tree constructed by linking two recursively generated trees.
By a careful choice of \\( z \\), this allows to generate large trees of
necessary size in quasilinear time.

We are currently [developing](software.html) a polynomial-time tuning framework which allows to design flexible Boltzmann samplers.

### Useful links

* The *purple book* entitled [Analytic
  Combinatorics](http://algo.inria.fr/flajolet/Publications/book.pdf) is an
equivalent of Bible in our field. You can also follow an
[online-course](https://www.coursera.org/learn/analytic-combinatorics).

* [ALEA Network](http://gt-alea.math.cnrs.fr) is a French portal containing event
  announcements, links to different research groups, courses and software,
internships, etc.

* [Laboratoire d'Informatique de Paris Nord](https://lipn.univ-paris13.fr), see
  also equipe [CALIN](https://lipn.univ-paris13.fr/accueil/equipe/calin/)
