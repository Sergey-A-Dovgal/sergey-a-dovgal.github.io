---
layout: page
title: Software
ref: software
lang: en
---

# Paganini

*paganini* is a lightweight *python* library for tuning multiparametric
combinatorial specifications. Installation is easy:

```
pip install --user paganini
```

* [[Tutorial]](https://paganini.readthedocs.io/en/latest/tutorial.html)

* [[Documentation]](https://paganini.readthedocs.io)

* Source code on [[Github]](https://github.com/maciej-bendkowski/paganini)

* If you use `paganini` or its components for published work, we encourage you
  to cite the accompanying paper [Polynomial tuning of multiparametric
combinatorial samplers](https://epubs.siam.org/doi/10.1137/1.9781611975062.9).
You can import the following BibTeX citation:
```
   @inproceedings{paganini,
     title        = {Polynomial tuning of multiparametric combinatorial samplers},
     author       = {Bendkowski, Maciej and Bodini, Olivier and Dovgal, Sergey},
     booktitle    = {2018 Proceedings of the Fifteenth Workshop on Analytic Algorithmics and Combinatorics (ANALCO)},
     pages        = {92--106},
     year         = {2018},
     organization = {SIAM}
   }
```

# Boltzmann Brain

*Boltzmann Brain* is a Haskell library and standalone application meant for
random generation of combinatorial structures. It can be used together with
*paganini* for multiparametric random generation.

* The input specification format mimics that of [Haskell algebraic data types](https://wiki.haskell.org/Algebraic_data_type) where in addition each
type constructor may be annotated with an additional *weight* parameter. For instance:
```hs
-- Motzkin trees
MotzkinTree = Leaf
            | Unary MotzkinTree (2) [0.3]
            | Binary MotzkinTree MotzkinTree.
```
* In the above example, a ```MotzkinTree``` data type is defined. It contains three
constructors:

    - a constant ```Leaf``` of weight one (default value if not
    annotated);
    -  a unary ```Unary``` constructor of weight two, and
    - a binary contructor ```Binary``` of default weight one.

    Here, the ```Unary``` construct is given weight *2* and a target frequency of
    *0.3*. In consequence, the system is to be **tuned** such that the ```Unary```
    node contributes, on average, *30%* of the total size of constructed Motzkin
    trees.  It is hence possible to distort the natural frequency of each
    constructor in the given system.

* See the source code and installation instructions on
  [[Github]](https://github.com/maciej-bendkowski/boltzmann-brain)

* You can find a bunch of combinatorial examples [[in another
  repository]](https://github.com/maciej-bendkowski/multiparametric-combinatorial-samplers).

