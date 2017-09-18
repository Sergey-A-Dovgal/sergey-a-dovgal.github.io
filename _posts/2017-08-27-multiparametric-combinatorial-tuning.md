---
title: "Multiparametric combinatorial tuning"
layout: post
lang: en
ref: multiparametric-tuning
---

# What is combinatorial sampling?

## Warm-up example: binary trees

First, define a binary tree. In principle, we are all familiar from graph theory
with the concept of tree, which is a graph withour cycles. In rooted trees,
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

> Let's show some `python` pseudocode of the generation process.
> [Try this code online!](https://goo.gl/HRnqpx){:target="_blank"}

<details>
<summary> Click to show python pseudocode </summary>
{% highlight python %}
# n-1 is a target tree size
n = 10
# Let us fill the array of T_k by recursion
T = [0] * n
T[1] = 1
# Precompute array T_k
for k in xrange(2,n):
    \\( \sum_{i=1}^n \\)
    T[k] = sum([
        T_a * T_b # T_a = T_k, T_b = T_{n-k-1}
        for (T_a, T_b)
        in zip(T[1:k], reversed(T[1:k-1]))
    ])
# Generate tree of size n

{% endhighlight %}
</details><br>

> **Remark**. We use quadratic algorithm to precompute the values \\( T_k \\).
> In fact, this can be done in linear time. Moreover, for any combinatorial
> system corresponding to *unambiguous context-free grammar* this can be done in
> linear arithmetic time (using so-called *holonomic specifications*).

## The Boltzmann sampler

As often happens, this sampler was not invented by Boltzmann, but rather by
Duchon, Flajolet, Louchard and Schaeffer. 
