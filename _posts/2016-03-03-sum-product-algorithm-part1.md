---
title: "Factor Graphs, Sum-Product Algorithm. Part 1."
layout: post
lang: en
ref: sumproduct1
tags:
    statistics
    clustering
---

* Mood: <a href="https://music.yandex.ru/album/215667" target="_blank">
The Mars Volta, «De-Loused in Comatorium»
</a>
* Estimated time: 60-90 minutes.

# What is this about?
                    
In Moscow we have a joint seminar on [Statistical Clustering Analysis](http://www.machinelearning.ru/wiki/index.php?title=Статистический_кластерный_анализ_(регулярный_семинар)) for students from MSU, HSE, MIPT, IITP. Recently I have had a report on this seminar on Sum-Product Algorithm and Factor Graphs. I am not a specialist in the field, but gratefully, the report gave birth to some fruitful discussion on influence of Bayesian methods and Statistical Physics in Image Processing. After brief googling I found two rather profound articles (in Russian):
[(1) Gibbs Random Fields](http://www.jip.ru/2013/141-170-2013.pdf) and [(2) Random Fields and Markov Chains in Image Processing](http://osmf.sscc.ru/~smp/Winkler-2rus-2008.pdf). The first one is purely theoretically-physical, the second one is more about image processing and Bayesian inference.

The whole story is based upon the article «[Factor Graphs and the Sum-Product Algorithm (2001)](http://vision.unipv.it/IA2/Factor%20graphs%20and%20the%20sum-product%20algorithm.pdf)» by Kschischang, Frey, Loeliger. Initially, I have studied this article in order to understand the idea standing behind a clustering algorithm «[Affinity Propagation](https://en.wikipedia.org/wiki/Affinity_propagation)». There is also a couple of publications concerning Affinity Propagation, by Frey and Dueck. The Affinity Propagation is a direct competitor of our Adaptive Weight Clustering algorithm, so we wanted to «know the enemy in person».

It turned out that idea of factor graphs is much more general than a single clustering algorithm, and it is a very beautiful piece of math. The difference between the original article and this post is the following: 
here I will try to emphasize the key points of my report at our clustering seminar, and refine some unclear points. Some technicalities and proofs might be omitted. However, it is worth noticing that the original article is almost perfect, so there is not much I can do. Much of the material is simply copy-pasted from there.

I should also warn a reader that, as already been said, I am not a specialist in Bayesian theory and graphical models. It is completely possible that I have missed some natural analogies – please do not hesitate to point that out in comments!

The sum-product algorithm for factor graphs, in fact, generalize the following things: Forward-Backward Algorithm, Viterbi Algorithm for Markov Chains, Kalman Filter, Fast Fourier Transform, and some algotihms from Linear Code Theory. It is quite a lot, so I will try to exhibit, how all this things can be incorporated in a pretty simple model of message passing in a bipartite graph. This is only the first part, so only one application will be covered.

# Sum-product algorithm for marginal functions

Let us start with the following problem.

Let \\( x\_1, \ldots, x\_n \\)  be a collection of variables, in which, each variable takes values only in some finite alphabet
$ \Sigma $.
Let \\( g(x\_1, \ldots, x\_n) \\) be some real-valued function with some specific internal structure that we will discuss later.
We are interested in computing the *marginal* functions:
\\[
    g\_i(x\_i) \overset{def}= \sum\_{x\_1} \cdots \sum\_{x\_{i-1}} \sum\_{x\_{i+1}} \cdots \sum\_{x\_{n}} g(x\_1, \ldots, x\_n),
\\]
where the value \\( g\_i(a) \\) is obtained by summing \\( g(x\_1, \ldots, x\_n) \\) over all configurations of the variables with \\( x\_i = a \\). The authors of the original article invented a special notation for the sums of this kind:
\\[
    g\_i (x\_i) = \sum\_{\sim \\{ x\_i \\}} g(x\_1, \ldots, x\_n)
\\]
For example, if \\( h \\) is a function of three variables, then
\\[
    h\_2(x\_2) = \sum\_{\sim \\{ x_2 \\}} h(x\_1, x\_2, x\_3) = \sum\_{x\_1} \sum\_{x\_3} h(x\_1, x\_2, x\_3).
\\]
In general, one needs to take exponential number of steps to compute the function. So, we need some assumptions, which exhibit the underlying structure of the function. We suppose that the function \\( g(x\_1, \ldots, x\_n) \\) factors into a product of several *local functions*, i.e.
\\[
    g(x\_1, \ldots, x\_n) = \prod\_{j \in J} f\_j (X\_j),
\\]
where each \\( X\_j \\) is a subset of \\( \\{ x\_1, \ldots, x\_n \\} \\), and \\( J \\) is a discrete index set. You can find an example several lines below.

Why this problem is interesting? Why do we consider this particular structure? Do we often meet such factorizations in reality?

Well, later we will show that such factorizations occur quite often in various problems, as was promised at the beginning of the post. However, the problem of finding a marginal sum is only one of the possibilities. Once we get the idea of marginal sums, we will be able to move further.

> **Definition.**
>
> A *factor graph* is a bipartite graph that expresses the structure of the factorization. The first part represents the variables, and the second part represents the functions. There is an edge from variable node \\( x\_i \\) to *factor node* \\( f_j \\) if and only if \\( x\_i \\) is an argument of \\( f\_j \\). 

> **Example.**
>
> Let \\[ g(x\_1, x\_2, x\_3, x\_4, x\_5) = f\_A(x\_1) f\_B(x\_2) f\_C(x\_1, x\_2, x\_3) f\_D(x\_3, x\_4) f\_E(x\_3, x\_5). \\] Then the factor graph corresponds to the one shown in the figure:
>
<center>
<img src="{{site.baseurl}}/pic/factor_graphs/2016-03-03-1.png">

</center>

## Expression tree

If the factor graph does not contain cycles, then it can be represented as a tree.

<center>
<img src="{{site.baseurl}}/pic/factor_graphs/2016-03-03-3.png">
</center>

It is not always true that graph does not contain cycles. We shall begin with the situation where factor graph is a tree, and then we will provide some ideas of how it could be generalized. In fact, most insteresting situations are described by graphs that do contain cycles!

The situation can be used to simplify the computations using the distributive law. Suppose we want to find \\( g\_1(x\_1) \\) from the previous example. Then we can compute marginal sums for nodes \\( x\_4, x\_5 \\) first, then «pass the messages» from \\( f\_D, f\_E \\) to node \\( x\_3 \\) (we shall see later what exactly this message passing means), then compute marginal sums for \\( x\_3 \\) and so on.


More formally, using the distributive law, the marginal for \\( g\_1(x\_1) \\) can be expressed as following:
\\[
    g\_1 (x\_1) = f\_A (x\_1) 
    \Big( \sum\_{x\_2} f\_B(x\_2) 
    \Big( \sum\_{x\_3} f\_C(x\_1, x\_2, x\_3) 
    \Big( \sum\_{x\_4} f\_D(x\_3, x\_4)
    \Big) 
    \Big( \sum\_{x\_5} f\_E(x\_3, x\_5)
    \Big)
    \Big) 
    \Big)
\\]
Moreover, in summary notation, i.e. using \\( \sum\_{\sim \\{ x \\}} \\) instead of \\(\sum\_{x}\\), the same sum can be expressed as
\\[
    g\_1(x\_1) = f\_A (x\_1) \sum\_{\sim \\{x\_1 \\}} \Big(
    f\_B(x\_2)f\_C(x\_1, x\_2, x\_3)  
    \Big(
        \sum\_{\sim \\{x\_3\\}} f\_D(x\_3, x\_4)
    \Big)
    \Big(
        \sum\_{\sim \\{x\_3\\}} f\_E(x\_3, x\_5)
    \Big)
    \Big)
\\]

It can take a while until one checks the correctness of the expression.

> **Exercise.**
>
> Write the decomposition of the same kind for \\( g\_3 (x\_3) \\).

> **Proposition.**
>
> When a factor graph is cycle-free, the factor graph not only encodes
> in its structure the factorization of the global function, but also
> encodes arithmetic expressions by which the marginal functions
> associated with the global function may be computed.

> **Exercise.**
>
> Do we reduce the complexity of the computation of marginal sums using such decompositions
> instead of brute-force summation?

## Computing marginal functions

As for now, the tree has been «hanged» by the node \\( x\_1 \\), and we managed to calculate the marginal sum \\( g\_1(x\_1) \\). If we want to compute marginal sum \\( g\_3(x\_3) \\), current technique allows only to re-hang the tree and re-do the whole procedure with another decomposition. Firstly, we will understand how to make the process automatical for one marginal sum, and then we will modify the procedure to make it possible to calculate all the marginal sums.

In order to compute all the marginal functions, we can initiate the message-passing procedure at the leaves. Any vertex waits for all the messages from children to come, i.e. remains idle until messages have arrived on all but one of the edges incident on \\( v \\).

What is the *message*? Suppose there is an edge \\( \\{x, f\\} \\), connecting variable \\( x\\) to function node \\( f\\). No matter which direction points the edge, the message will always be some function of single variable \\( x\\), say \\( \varphi\_{ \\{x, f\\} }(x) \\). Each node receives some messages and then sends one message.

We initialize the process at leaves.
During the initialization,
each leaf *variable* node \\( x\\) sends a trivial «identity function» (\\( \varphi(x) \equiv 1 \\)) message to its parent, and each leaf *factor* node \\( f\\), sends a description of \\( f \\) to its parent. Note that if \\( f\\) is a leaf node, then the function \\( f\\) depends on a single variable.

Let us introduce the following update rules:

<center>
<img src="{{site.baseurl}}/pic/factor_graphs/2016-03-03-2.png">
</center>

During each step, each *variable* node waits for the messages from all the children, and then simply sends the product of messages received from its children.

A *factor* node \\( f \\) with parent \\( x \\) forms the product of \\( f \\) with the messages received by the children, and then operates on the result with a \\( \sum\_{\sim \\{ x \\}} \\) summary operator.

Let \\( n(v) \\) denote the set of neighbors of a given node \\( v\\).
 The message computation can be expressed as following:

### variable to local function:
\\[
    \mu\_{x \to f} (x) = \prod\_{h \in n(x) \backslash \\{f\\}} \mu\_{h \to x} (x)
\\]

### local function to variable:
\\[
    \mu\_{f \to x} (x) = \sum\_{\sim \\{x\\}} \Big(
    f(X) \prod\_{y \in n(f) \backslash \\{x\\}} \mu\_{y \to f} (y)
    \Big)
\\]

In this framework, the computation terminates at the root node \\( x\_i \\), because the tree is hanged by the node \\( x\_i \\). The marginal function \\( g\_i (x\_i) \\) is obtained as the product of all messages received at \\( x\_i \\).

> **Exercise.**
>
> Check that for the above example the suggested message-passing procedure leads to correct decomposition for \\( g\_1(x\_1) \\).

This procedure is perfect if we want only one marginal, but let us think how it could be modified for multiple marginals. 

If we want to compute all the marginals, then no particular vertex is taken as a root vertex. Thus, there is no more child-parent relationship between nodes. Therefore, we need to change our message-passing scheme.

Message passing is again initiated at the leaves. Again, each vertex remains idle until messages have arrived on all but one of the edges incident on \\( v \\). Once the messages have arrived, \\( v \\) is able to compute a message to be sent on the one remaining edge to its neighbor. After sending a message, vertex \\( v \\) returns to the idle state, waiting for the return message. Once the message has arrived, the vertex is able to compute and send messages to its other neighbors. The algorithm terminates once two messages have been passed over every edge, one in each direction.

<center>
<img src="{{site.baseurl}}/pic/factor_graphs/2016-03-03-4.png">
</center>


## Example of message-passing procedure

For the function mentioned in the very beginning, we can depict the order in which the messages are passed:

<center>
<img src="{{site.baseurl}}/pic/factor_graphs/2016-03-03-5.png">
</center>

In detail, the messages are generated as follows:
#### Step 1.
\begin{align}
    \mu\_{A \to 1} (x\_1) &= \sum\_{\sim \\{x\_1 \\}} f\_A(x\_1) = f\_A (x\_1)  \\\
    \mu\_{B \to 2} (x\_2) &= \sum\_{\sim \\{x\_2 \\}} f\_B(x\_2) = f\_B (x\_2)  \\\
    \mu\_{4 \to D} (x\_4) &= 1                                                  \\\
    \mu\_{5 \to E} (x\_5) &= 1.
\end{align}
#### Step 2.
\begin{align}
    \mu\_{1 \to С} (x\_1) &= \mu\_{A \to 1} (x\_1)  \\\
    \mu\_{2 \to С} (x\_2) &= \mu\_{B \to 2} (x\_2)  \\\
    \mu\_{D \to 3} (x\_3) &= \sum\_{\sim \\{x\_3\\}} \mu\_{4 \to D} (x\_4) f\_D (x\_3, x\_4)                                                  \\\
    \mu\_{E \to 3} (x\_3) &= \sum\_{\sim \\{x\_3\\}} \mu\_{5 \to E} (x\_5) f\_E (x\_3, x\_5) .
\end{align}

#### Step 3.
\begin{align}
    \mu\_{C \to 3} (x\_3) &= \sum\_{\sim \\{x\_3\\}} \mu\_{1 \to C} (x\_1) \mu\_{2 \to C} (x\_2) f\_C (x\_1, x\_2, x\_3) \\\
    \mu\_{3 \to C} (x\_3) &= \mu\_{D \to 3} (x\_3) \mu\_{E \to 3}  (x\_3)
\end{align}

#### Step 4.
\begin{align}
    \mu\_{C \to 1} (x\_1) &= \sum\_{\sim \\{x\_1\\}} \mu\_{3 \to C} (x\_3) \mu\_{2 \to C} (x\_2) f\_C (x\_1, x\_2, x\_3) \\\
    \mu\_{C \to 2} (x\_2) &= \sum\_{\sim \\{x\_2\\}} \mu\_{3 \to C} (x\_3) \mu\_{1 \to C} (x\_1) f\_C (x\_1, x\_2, x\_3) \\\
    \mu\_{3 \to D} (x\_3) &= \mu\_{C \to 3} (x\_3) \mu\_{E \to 3} (x\_3) \\\
    \mu\_{3 \to E} (x\_3) &= \mu\_{C \to 3} (x\_3) \mu\_{D \to 3} (x\_3).
\end{align}

#### Step 5.

\begin{align}
    \mu\_{1 \to A} (x\_1) &= \mu\_{C \to 1} (x\_1) \\\
    \mu\_{2 \to B} (x\_2) &= \mu\_{C \to 2} (x\_2) \\\
    \mu\_{D \to 4} (x\_4) &= \sum\_{\sim \\{x\_4\\}} \mu\_{3 \to D} (x\_3) f\_D (x\_3, x\_4)                                                  \\\
    \mu\_{E \to 4} (x\_5) &= \sum\_{\sim \\{x\_5\\}} \mu\_{3 \to E} (x\_3) f\_E (x\_3, x\_5)                                                  \\\
\end{align}

#### Termination.

\begin{align}
    g\_1(x\_1) &= \mu\_{A \to 1} (x\_1) \mu\_{C \to 1} (x\_1)\\\
    g\_2(x\_2) &= \mu\_{B \to 2} (x\_2) \mu\_{C \to 2} (x\_2)\\\
    g\_3(x\_3) &= \mu\_{C \to 3} (x\_3) \mu\_{D \to 3} (x\_3) \mu\_{E \to 3} (x\_3)\\\
    g\_4(x\_4) &= \mu\_{D \to 4} (x\_4) \\\
    g\_5(x\_5) &= \mu\_{E \to 5} (x\_5)
\end{align}


# Some remarks

## Semiring trick
                                                                                                                    
One can note that marginal sums involve two operations: \\( \\{+, \times\\} \\) and these two operations satisfy distributive law. In fact, we can use any two operations that satisfy the distributive law, and this is the case of *commutative semiring*. For example, if we are searching for maxima \\( \max f(x\_1, \ldots, x\_n) \\), we can use the family \\( \\{\max, \times\\} \\), where \\( \max \\) now plays the role of sum. This allows to formulate another interesting optimization algorithm in terms of factor graph!

## Factor graphs with cycles

If we want to allow cycles in the graph, there will be no simple terminating condition, and hence, messages might pass  miltiple times on each edge, and this is ok. Many interesting applications involve the situations where graph *does have cycles*. 

We convent that every node should pass a message along every edge at every time, assuming that passing of the messages in synchronized with some «global clock». In fact there are possible many message-scheduling strategies, and several of them are described in the original article.

It is important to emphasize that we do not initialize nodes, but we do initialize edges. So, during the initialization
 we assume that a unit message has arrived on every edge incident on any given vertex.

> **Exercise.**
>
> Check that if the graph does not have any cycles, then this initialization does not affect the final result, and does not affect the number of steps until convergence. 

So, the factor graphs obtained from this function, contains cycles, but which guarantees can be given for such an algorithm? It turns out that iterations of Sum-Product algorithm minimize some Kullback-Leibler divergence. So, there exists some invariant that is minimized by our procedure. Let us do it step by step.

# Bethe method

The following theorem claims that there exists a certain structure in probability distributions, which can be represented as a product in case when factor graph does not have cycles. We will not concentrate on the particular form of the expression in the theorem.

> **Proposition** (Mean Field Approximation)
>
> Let us denote by \\( N(a) \\) the set of arguments of function with index \\( a\\), and by \\( d\_i \\) – the cardinality of neighbors of \\( x\_i \\).
>
> Suppose \\( p(\boldsymbol x) \\) is a probability function in the factor form, i.e.
> \\[
>   p(\boldsymbol x) = \prod\_{a = 1}^{M} q\_a(\boldsymbol x\_{N(a)})
> \\]
> and the corresponding factor graph has no cycles.
> Then it can be expressed as follows:
> \\[
>   p(\boldsymbol x) = \dfrac{\prod\_{a=1}^M p\_a(\boldsymbol x\_{N(a)})}{\prod\_{i=1}^N (p\_i(x\_i))^{d\_i - 1}},  
> \\]
> where the functions \\( p\_n (x\_n) \\) and \\( p\_{a}(\boldsymbol x\_{N(a)}) \\) obey the following restrictions:
> \begin{align}
    \sum\_{x\_n} p\_n (x\_n) &= 1 \quad \forall n \in [1, N], \\\
    \sum\_{\boldsymbol x\_{N(a)}} p\_a(\boldsymbol x\_{N(a)}) &= 1,\\\
    \sum\_{\boldsymbol x\_{N(a) \backslash n}} p\_a(\boldsymbol x_{N(a)}) &= p\_n(x\_n) \quad \forall n \in [1, N].
\end{align}

> **Exercise.**
>
> Find the Bethe decomposition for the function from the example, assuming that it is a probability function.

Recall that all the variables \\( x\_1, \ldots, x\_n \\) take values only in some finite alphabet \\( \Sigma \\).
It means that function of a single variable \\( x\_i \\) can be represented as a vector of length \\( \|\Sigma\| \\). It means that Bethe decomposition can be parametrized with some fixed number of parameters.

> **Theorem.**
>
> If the factor graph for \\(p(\boldsymbol x)\\) has cycles, then the sum-product updates are equivalent to coordinate descent minimization of the KL-divergence between \\( p(\boldsymbol x)\\) and bethe-type distribution.

The proof and detailed formulation of the theorem can be found in the Appendix A of [PhD Thesis of Delbert Dueck](http://www.cs.columbia.edu/~delbert/docs/DDueck-thesis_small.pdf).

Now we are ready for some applications.

# Modeling Systems with Factor Graphs

## Affinity propagation.

Affinity propagation is a clustering algorithm. Its goal is to maximize *net similarity*.

The problem is formulated as follows: we are given a set of observations \\( X\_1, \ldots, X\_n \\), and a matrix of similarities \\( s(i, j) \\). We often cannot observe the variables \\( X\_1, \ldots, X\_n \\) themselves, but we always observe the similarity matrix.

In case of metric clusterization problem, i.e. \\( X\_j \in \mathbb R^d\\) we can choose similarities like \\( s(i, j) = - d(X\_i, X\_j) \\) for \\( i \neq j\\), but for \\( i = j\\) we must have \\( s(X\_i, X\_j) \neq 0 \\). In fact, there are several possible strategies to define similarity of a vertex to itself:
\\[
    s(i, i) = -\lambda; \quad \text{or} \quad
    s(i, i) = \mathrm{Median}_{j}(s(i, j))
\\]                             
We would like to choose *exemplars* \\( c\_1, c\_2, \ldots, c\_n \\) among the points of dataset, \\( c\_i \in \\{X\_1, \ldots, X\_n \\} \\) such that the sum of similarities
\\[
    \sum\_{i = 1}^{n} s(i, c\_i)
\\]
is maximal. However, there is one restriction, preventing us from the greedy assignment.
\\[
    (c\_i = k) \, \Rightarrow \, (c\_k = k),
\\] 
i.e. the assignment of exemplars is correct. If point \\( X\_k \\) is an exemplar for point \\( X\_i \\), then it should be an exemplar for itself. The requirement can be re-formulated as follows: the set of points is splitted into disjoint sets of points, where each set has its own unique exemplar.

<center>
<img src="{{site.baseurl}}/pic/factor_graphs/2016-03-03-7.png" alt="Reference: Brendan J. Frey and Delbert Dueck, Clustering by Passing Messages Between Data Points, Science Feb. 2007"> <br>
Reference: Brendan J. Frey and Delbert Dueck, “Clustering by Passing Messages Between Data Points”, Science Feb. 2007
</center>

The optimization problem can also be interpreted as the [*Facility Location Problem*](https://en.wikipedia.org/wiki/Facility_location_problem), which is known to be NP-hard.

It turns out that the optimized function with the correctness restriction can be modified and turned into another single function with no restrictions. Namely, we consider 
\\[
    F(\boldsymbol c, \boldsymbol s) = \prod\_{i=1}^{N} e^{s(i, c\_i)} \prod\_{k=1}^{N} f\_k (\underbrace{c\_1, \ldots, c\_N}\_{\boldsymbol c})
\\]
The second term contains a correctness constraint defined as follows:
\\[
    f\_k(\boldsymbol c) = \begin{cases}
    0, & c\_k \neq k, \, \exists i \colon c\_i = k\\\
    1, & \mathrm{otherwise}
\end{cases}
\\]

This function naturally produces the factor graph:
<center>
<img src="{{site.baseurl}}/pic/factor_graphs/2016-03-03-8.png">
</center>

In fact, the analysis of message-passing for this function \\( F(\boldsymbol c, \boldsymbol s) \\) is quite cubersome, we need to consider several cases for valid and invalid configurations. The messages passing between \\( c\_i\\) and \\( f\_j \\) are most important, while messages between \\( s(i, c\_i) \\) and \\( c\_i \\) can be easily eliminated. The authors of Affinity Propagation show that max-product algorithm update equations for the functional, after some variable notation change, can be transformed into very simple form:

> **Affinity Propagation**
>
> 1. Set \\( a(i, k) \\) to zero (availabilities).
> 2. Repeat until convergence:
>   * \\( \forall i, k \colon r(i, k) = s(i, k) - \max\_{k' \neq k} [s(i, k') + a(i, k')] \\)
>   * \\( \forall i, k \colon a(i, k) = \begin{cases}
>      \sum\_{i' \neq i} [r(i', k)]\_{+}, & k = i\\\
>      [r(k,k) + [r(i', k)]_{+}]\_{-}, & k \neq i
>   \end{cases} \\)
> 3. Output: cluster assignments.
>   * \\( \hat{\boldsymbol c} = (\hat c\_{1}, \ldots, \hat c\_{N}) \\), where
>   * \\( \hat c_i = \arg\max\_{k} [a(i,k) + r(i,k)] \\)

Note that this algorithm is rather heuristic than theoretically justified, because of the several reasons:

* There is justification via KL-divergence only for Sum-Product algorithm, but not for Max-Product. One can use the Sum-Product version of Affinity Propagation,  but it neither makes sense, nor is computational as simple as Max-Product version.
* Algorithm may converge to invalid configuration. In this case, one needs to restart it, until we get valid configuration. There are no theoretical guarantees on the number of restarts.

However, it is claimed to have great practical performance.

Other interpretations of Affinity Propagation, including some probabilistic ones, can be found on its [FAQ Page](http://www.psi.toronto.edu/affinitypropagation/faq.html).
