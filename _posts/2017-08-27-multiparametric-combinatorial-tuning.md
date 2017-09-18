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

# What is combinatorial sampling?

## Warm-up example: binary trees and Catalan numbers

First, define a binary tree. In principle, we are all familiar from graph theory
with the concept of tree, which is a graph without cycles. In rooted trees,
there is one distinguished vertex called *root* and starting from the root, each
node is assigned height which is the distance to the root. In its turn, binary
trees are those trees whose nodes have either zero or two children.

So, binary trees admit a kind of recursive definition:

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

### Random facts about Catalan numbers that you maybe didn't know
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

In order to give the answer, let's turn to combinatorics. Suppose that the number of binary trees with \\( k
\\) is equal to \\( T_k \\) and has been precomputed for all \\( k \leq n \\).
How to compute the number of trees of size \\( n \\) if all the numbers \\( T_k
\\) are known for \\( k < n \\)? After summing over all possible \\( k \\), we
obtain:
\\[
    T_n = \sum_{k=1}^n T_k T_{n-k-1}
    \enspace .
\\]
This equation gives the answer on what should be the probability distribution,
the probability of having \\( k \\) vertices in the left subtree should be
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

As often happens, this sampler was not invented by Boltzmann, but rather by
Duchon, Flajolet, Louchard and Schaeffer.  The name *Boltzmann* stands for
Boltzmann distribution.

At this point we need to define *generating function* of binary trees.
Generating function is a formal power series that contains information about all
the coefficients \\( T_k \\) in the following way:
\\[
    T(z) := T_0 + T_1 z + T_2 z^2 + \ldots
\\]
This function can be even computed at some points \\( z \\), for example
\\( T(0.5) = 1 \\). Pure magic. 

You can believe me that in fact, there is a famous formula for Catalan numbers.
\\[
    T(z) = \dfrac{1 - \sqrt{1 - 4z^2}}{2z}
\\]
This can be proved by solving quadratic equation with respect to \\( T \\)
\\[
    T(z) = z + z T^2(z)
\\]
which follows from the reccurence relation on its coefficients.

> **Boltzmann sampler algorithm for binary trees**. [Try this code online!]
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

The goal is to choose \\( z = z_n \\) so that the *expected* size of returned
object will be exactly \\( n \\). This size is not a constant, but for
approximate-size generation, Boltzmann samplers can be more efficient.

## Multiparametric sampling

in progress...
