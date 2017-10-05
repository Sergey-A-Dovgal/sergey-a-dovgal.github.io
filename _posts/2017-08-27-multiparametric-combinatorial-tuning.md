---
title: "Multiparametric combinatorial tuning"
layout: post
lang: en
ref: multiparametric-tuning
---

This note accompanies our recent paper
[[Polynomial tuning of multiparametric combinatorial samplers]](https://arxiv.org/abs/1708.01212){:target="\_blank"}
with Olivier Bodini and Maciej Bendkowski.

Here I present the main statements (not proofs) illustrated by examples.
This note is also accompanied by an `ipython` notebook with clarifying simulations and code examples.
[[Try the code online!]](
https://nbviewer.jupyter.org/github/Electric-tric/electric-tric.github.io/blob/gh-pages/ipynb/Recursive%20generation.ipynb#){:target="\_blank"}

We also wrote implementation which became a part of Maciej's sampler `boltzmann-brain`.
The implementation is a mixture of `Haskell` and `python` so it's a bit tricky
to configure and make it work, but [[you can
try]](https://github.com/maciej-bendkowski/boltzmann-brain). You can find a
bunch of combinatorial examples [[in another repository]](https://github.com/maciej-bendkowski/multiparametric-combinatorial-samplers).

Finally, I invite you to start a discussion / participate at the bottom of
the page.

## Warm-up example: binary trees and Catalan numbers

First, define a binary tree. In principle, we are all familiar from graph theory
with the concept of tree, which is a graph without cycles. In rooted trees,
there is one distinguished vertex that we call a *root*.
The height of a node is the distance from this node to the root. If two nodes
are adjacent then the node with greater height is calles a **child**, and the
other one is called a **parent**.
Binary trees are those trees whose nodes have either zero or two children.

Then, binary trees admit a kind of recursive definition:

> **Definition.**
>
> A binary tree is either a *leaf* or a *root* with two *binary trees*
> ![](/pic/polynomial-tuning/27-08-17-01.png)

Binary trees can be also represented by an unambiguous context-free grammar:
\\[
    B = \mathcal Z \mid (B) \mathcal Z (B)
\\]
The symbol \\( \mathcal Z \\) is a terminal symbol of this grammar (a leaf
vertex), and the brackets <<(>>, <<)>> are auxilliary symbols.
Thus, this grammar describes the set of words
\\(
    \def\Z{\mathcal Z}
\\)
\\[
    \\{
        \Z,
        (\Z)\Z (\Z),
        ((\Z)\Z (\Z)) \Z (\Z),
        (\Z) \Z ((\Z)\Z (\Z)),
        \ldots
    \\}
\\]

> **Problem.**
>
> Generate uniformly at random binary trees with \\( n \\) nodes.

In the long run, the problem of random generation will become a bit more general
than this, but we need to start with a simple example.
Essentially, we consider two algorithms which solve this problem.

### offtopic. Random facts about Catalan numbers that you maybe didn't know
Let \\( T_k \\) denote the number of binary trees with \\( n \\)
nodes. The sequence of nonzero \\( T_k \\), i.e. the subsequence with
odd indices, is called a sequence of **Catalan numbers**.

> **Random fact 1.** 
\\[
    T_{2n + 1} = \dfrac{1}{2 \pi} \int_0^4 x^n
    \sqrt{ \dfrac{4-x}{x}} dx
\\]

> **Random fact 2.** 
If \\( T\_{2n+1} \\) is an odd number then \\( n = 2^k - 1 \\).

> **Random fact 3.** Matrix \\( n \times n \\) whose entries at index \\( (i,j) \\)
are \\( T\_{2i+2j-1} \\) has determinant \\(1\\):
\\[
    \det \begin{bmatrix}
        1  & 2  & 5   & 14 \\\
        2  & 5  & 14  & 42 \\\
        5  & 14 & 42  & 132 \\\
        14 & 42 & 132 & 429 \\\
    \end{bmatrix} = 1
\\]

## The recursive method

The recursive method is a kind of algorithm which uses dynamic programming.
In order to generate a tree of size \\( n \\), we choose some \\( k \\)
at random, and generate left subtree with \\( k \\) nodes and right subtree with
\\( n-k-1 \\) nodes. But what should be the distribution of random variable \\( k \\)?

In order to give the answer, let's turn to combinatorics.
Suppose that the number of binary trees with \\( k \\) nodes is equal to \\( T_k \\)
and has been precomputed for all \\( k \leq n \\).
How to compute the number of trees of size \\( n \\)
if all the numbers \\( T_k \\) are known for \\( k < n \\)?
After summing over all possible \\( k \\), we obtain:
\\[
    T_n = \sum_{k=1}^n T_k T_{n-k-1}
    \enspace .
\\]
The probability of having \\( k \\) vertices in the left subtree should be
proportional to \\( k \\)-th summand in the previous sum:
\\[
    \mathbb P(k \text{ nodes in the left subtree}) = \dfrac{T_k T_{n-k-1}}{T_n}
\\]
Once all the values \\( T_1, \ldots, T\_{n-1} \\) are precomputed, it is
possible to recursively generate each required probability distribution on the
number of nodes in the left subtree. The tree is generated from the root until
each <<subprocess>> becomes a leaf node.

> **Recursive algorithm for binary trees**.
> [[Try this code online!]](
https://nbviewer.jupyter.org/github/Electric-tric/electric-tric.github.io/blob/gh-pages/ipynb/Recursive%20generation.ipynb#
){:target="_blank"} 
>
* Precompute array \\( (T\_k)\_{k=1}^n \\) using the reccurence
\\[
    T_n = \sum\_{k=1}^n T_k T_{n-k-1}
    \enspace ,
    \quad
    T_1 = 1 
\\]
* For each \\( n \\), precompute the probability distribution \\( \mathcal P_n \\):
\\[
    p\_k^{(n)} = \dfrac{T_k T_{n-k-1}}{T_n}
\\]
* Input: \\( n \\), target tree size
* Function `generate(n)`:
    * If \\( n = 1 \\) return \\( \mathcal Z \\).
    * Generate \\( k \\) from the probability distribution \\( \mathcal P_n \\).
    * Left subtree `L := generate(k)`
    * Right subtree `R := generate(n-k-1)`
    * Return `(L)Z(R)`, where `Z` stands for root node.


> **Remark**. We use quadratic algorithm to precompute the values \\( T_k \\).
> In fact, this can be done in linear time
> using a recursive formula
\\[
    T_{2n+1} = \dfrac{2(2n-1)}{n+1} T_{2n-1}
\\]
> Moreover, for any combinatorial
> system corresponding to *unambiguous context-free grammar* this can be done in
> linear arithmetic time (using so-called *holonomic specifications*).


## The Boltzmann sampler

As often happens, the sampler named after Boltzmann, was not invented by him.
This sampler is an invention of Duchon, Flajolet, Louchard and Schaeffer.
The name *Boltzmann* stands for Boltzmann distribution.

In contrast to the previous sampler, Boltzmann sampler doesn't return objects of
fixed size, the size is a random variable. Hovewer, the sampler has an
additional parameter as an input, and this parameter can be changed to give
different expected values of size.

At this point we need to define *generating function* of binary trees.
Generating function is a formal power series that contains information about all
the coefficients \\( T_k \\) in the following way:
\\[
    T(z) := T_0 + T_1 z + T_2 z^2 + \ldots
\\]
This function can be even computed at some points \\( z \\), for example
\\( T(0.5) = 1 \\). Pure magic and beauty. 

There is a famous formula for Catalan numbers.
\\[
    T(z) = \dfrac{1 - \sqrt{1 - 4z^2}}{2z}
\\]
which can be proved by solving quadratic equation with respect to \\( T \\)
\\[
    T(z) = z + z T^2(z)
\\]
which, in its turn, follows from the reccurence relation on its coefficients.

> **Boltzmann sampler algorithm for binary trees**.
[[Try the code online!]](
https://nbviewer.jupyter.org/github/Electric-tric/electric-tric.github.io/blob/gh-pages/ipynb/Recursive%20generation.ipynb#){:target="\_blank"}
>
* Input \\(n\\), target *expected* tree size.
* Choose \\( z = z\_n \\) depending on \\( n \\), we will discuss this below.
* Function `generate(z)`:
    * Carefully look at the equation
    \\[
        T(z) = z + zT^2(z)
    \\]
    * Generate Bernoulli random choice with probability
    \\[
        \begin{cases}
            \mathbb P(X = 0) &= \dfrac{z}{z + z T^2(z)} \\\
            \mathbb P(X = 1) &= \dfrac{zT^2(z)}{z + z T^2(z)} 
        \end{cases}
    \\]
        * If \\( X = 0 \\) then return `Z` (tree with one node)
        * If \\( X = 1 \\) then
            * Left subtree `L := generate(z)`
            * Right subtree `R := generate(z)`
            * Return `(L)Z(R)` where `Z` stands for root node.

Let us look at the distribution of size when \\( z \\) is close to \\( 0.5 \\).

![](/pic/polynomial-tuning/27-08-17-02.png)   

>**Excercise**. The expected size of a generated object
from a Boltzmann sampler is equal to \\( z \dfrac{T'(z)}{T(z)} \\).
\\( T(z) \\) is the generating function associated with the class of objects.
Moreover, \\( z T'(z) / T(z) \\) is a non-decreasing function on \\( z \\), and
therefore, the tuning parameter \\( z_n \\) depending on given expected size \\(
n \\) can be computed with binary search.

Although the distribution depicted above, has expectation,
it is not very <<useful>> in practice if we want to obtain
objects of size approximately \\( 8 \\). For this reason, people use **rejection
sampling**, where objects with size not in
\\( [n(1 - \varepsilon), n(1 + \varepsilon)] \\) are rejected.

![](/pic/polynomial-tuning/27-08-17-03.png)   

>**Excercise**. Boltzmann samplers with approximate-size rejection return an
>object of size \\( n(1 + \delta) \\), \\( \delta \in [-\varepsilon,
>\varepsilon] \\) in linear time \\( C\_\varepsilon n \\).

## Multiparametric sampling

Let us switch to another example.

>**Problem**. Generate uniformly at random rooted trees with given number of
>nodes, leaves and vertices with 3 chlidren.

![](/pic/polynomial-tuning/27-08-17-04.png)   

Let us construct a trivariate generating function
\\[
    T(x, y, z) = \sum\_{n, j, k \geq 0}
    a_{njk} x^n y^j z^k
\\]
where \\( a\_{njk} \\) stands for the number of trees with given number \\( n
\\) of nodes, \\( j \\) leaves, and \\( k \\) nodes with 4 children.

\\[
    T(x, y, z) = x y + x \left( \dfrac{1}{1 - T} - T^3 \right) + x z T^3 
\\]
This is a 4-th degree equation on \\( T \\) which is not obvious to solve.

In fact, the best known solution to the mentioned problem (in case of
arbitrarily large number of parameters) is to generate random objects with
approximate parameter values and reject the objects if the size is not equal to
the given one. The complexity of such a sampling is exponential in the number of
parameters.

However, if we allow for approximate parameter values, the problem doesn't seem
to be impossible.

>**Problem**. Generate uniformly at random rooted trees with given approximate number of
>nodes, leaves and vertices with 3 chlidren. The word <<approximate>> means that
>the expected values of all the parameters should coincide with the given ones.
The word <<uniformly>> means that conditioned on size and parameter values, the
objects are drawn uniformly at random.

>**Excercise**.
Suppose that some magician gave us the variable values \\( x, y, z \\) depending on
given expected values of parameters. Verify that the algorithm for Boltzmann
sampling can be generalized in a straghtforward manner, and the uniformity
conditions are verified automatically.

>**Excercise**.
Verify that changing the weights in the recursive sampling algorithm, also gives
exact-size approximate parameter random generation procedure, which is also
uniform conditioned on parameter values.

The idea of tuning expected values of parameteres is not completely meaningless.
The distributions of most parameters in the system follow a Gaussian behaviour
with \\( \sqrt n \\)-deviation.

![](/pic/polynomial-tuning/27-08-17-05.png)   


## Multiparametric tuning

The problem of univariate tuning is to find a value \\( z \\) such that expected
size is equal to \\( n \\). As we discussed before, when \\( z \\) increases,
the expected size increases as well. This happens in multivariate case as well:
if we increase the value of some variable \\( y \\), then the expected values of
all other parameters should increase or stay the same. Unfortunately, it is not
possible to tune each value separately because each <<handle>> can influence
each expectation.


![](/pic/polynomial-tuning/27-08-17-06.png)   

The first naive approach requires nested binary searches, and this algorithm
still has an exponential complexity on the number of parameters. We propose a
different strategy which results in a polynomial tuning algorithm.

### Combinatorial specifications

Let's imagine ugly enough combinatorial systems involving several combinatorial
classes and variables (it is not necessary to try to understand the
combinatorics behind).

\\[
\begin{cases}
    A &= 1 + xy^2 B^2 + \dfrac{z BC}{1 - y C} + ABD^2 , \\\
    B &= x + A^3 + CD , \\\
    C &= \dfrac{y}{1 - yz} + C^3 + AD , \\\
    D &= B + C^4 \enspace .
\end{cases}
\\]

Each variable is replaced by an exponential, and equations are converted into
inequalities:
\\[
    A = e^\alpha, B = e^\beta, C = e^\gamma, D = e^\delta,
    x = e^\xi, y = e^\eta, z = e^\zeta
\\]
Suppose that \\( i, j, k \\) are random variables, corresponding to parameters
of objects from combinatorial class \\( A \\). Suppose that the values 
\\( \mathbb E i, \mathbb E j, \mathbb E k \\) are given.
Then \\( \xi, \eta, \zeta \\) can be obtained from a convex optimisation problem
\\[
\begin{cases}
           \alpha
            - \mathbb E i \cdot \xi
            - \mathbb E j \cdot \eta
            - \mathbb E k \cdot \zeta
            \to \min ,\\\
    \alpha \geq 1 + e^{\xi + 2 \eta + 2 \beta}
            + \dfrac{e^{\zeta + \beta + \gamma}}{1 - e^{\eta+\gamma}}
            + e^{\alpha + \beta + 2 \delta} , \\\
    \beta  \geq e^\xi + e^{3 \alpha} + e^{\gamma + \delta} , \\\
    \gamma \geq \dfrac{e^\eta}{1 - e^{\eta + \zeta}}
            + e^{3 \gamma}
            + e^{\alpha + \delta} , \\\
    \delta \geq e^\beta + e^{4 \gamma} \enspace .
\end{cases}
\\]

>**Theorem**. This approach works for a very general class of combinatorial
>systems, including rational, algebraic systems and some systems involving Polya
>structures as well.

The geometry of this transform is well illustrated by an example of binary
trees.
\\[
    \begin{cases}
        z \to \max , \\\
        T \geq z + z T^2
    \end{cases}
    \quad \Rightarrow \quad   
    \begin{cases}
        \zeta \to \max , \\\
        b \geq \log(e^\zeta + e^\zeta e^{2b})
    \end{cases}
\\]

![](/pic/polynomial-tuning/27-08-17-07.png)   

The point of singularity \\( z = 0.5 \\) corresponds to the right-most point of
the feasible set. After log-exp transform the feasible set becomes convex, which
makes it possible to apply polynomial optimisation algorithm.

## Examples

Many of the examples may look a bit <<artificial>> but we are aware of a few
more, which may be possibly included into an extended version of the paper.

### Random tilings

Consider a rectangle \\( 7 \times n \\). We construct a set of 126 possible
tiles, some exemplary tiles are shown below. The principle of construction is to
attach a subset of unit squares to the base layer which is a single connected
block. 

![](/pic/polynomial-tuning/27-08-17-08.png)   

A random tiling is generated from a rational grammar with a huge number of
states (more than 28000).

![](/pic/polynomial-tuning/27-08-17-09.png)   

### Tree-like structures with given degree distribution

Tree-like structures include rooted trees and also lambda terms in natural
size notion. 

![](/pic/polynomial-tuning/27-08-17-10.png)   

Don't be confused about observed frequency: this is a random variable with
expectation exactly equal to 8 percent.

### Weighted partitions.

In the last example, we recall that an *integer partition* is a multiset of
integer numbers:
\\[
    16 = 1 + 1 + 3 + 4 + 7
\\]
This partition can be represented as a Young diagram, a pyramid of 5 rows, with
respectively \\( 1, 1, 3, 4, 7 \\) unit squares in rows. A **coloured
partition** is a similar thing, but each row is itself a multiset of several
different colours (the total number of colours is fixed).

The model appears in various texts on statistical physics, and in short, the
total number of unit squares represents an enegry of the system of bosons,
the number of colours represents dimension of the space, and each row represents
a particle.

![](/pic/polynomial-tuning/27-08-17-11.png)   

