# Tropical Moduli Data

This repository contains data concerning various moduli spaces of tropical curves.

Contributions by:
Sarah Brodsky,
[Dominic Bunnett](http://page.math.tu-berlin.de/~bunnett),
[Holger Eble](http://page.math.tu-berlin.de/~eble),
[Michael Joswig](http://page.math.tu-berlin.de/~joswig),
[Julian Pfeifle](https://mat.upc.edu/en/people/julian.pfeifle/),
[Ayush Kumar Tewari](https://sites.google.com/view/ayushkumartewari/home)

As general references for tropical geometry see

* I. Itenberg, G. Mikhalkin, E. Shustin: Tropical algebraic geometry. Oberwolfach Seminars, 35. Birkhäuser Verlag, Basel, 2007

* D. MacLagan, B. Sturmfels: Introduction to tropical geometry. Graduate Studies in Mathematics, 161. American Mathematical Society, Providence, RI, 2015.

* M. Joswig: Essentials of tropical combinatorics.  Graduate Studies in Mathematics, 219. American Mathematical Society, Providence, RI, 2022. [(near final draft)](http://page.math.tu-berlin.de/~joswig/etc/index.html)

This repository is subdivided into directories, each of which corresponds to one publication.
For details see the `README.md` files in those subdirectories.

The main software reference is [polymake](https://www.polymake.org).

```
@incollection {GJ2000,
    AUTHOR = {Gawrilow, Ewgenij and Joswig, Michael},
     TITLE = {polymake: a framework for analyzing convex polytopes},
 BOOKTITLE = {Polytopes---combinatorics and computation (Oberwolfach, 1997)},
    SERIES = {DMV Sem.},
    VOLUME = {29},
     PAGES = {43--73},
 PUBLISHER = {Birk\-h\"au\-ser},
   ADDRESS = {Basel},
      YEAR = {2000},
}
```

If you use any of this data in your research please cite this repo and at least one of the references listed as BibTeX entries here.

## Moduli of tropical plane curves

We study the moduli space of metric graphs that arise from tropical plane curves. There
are far fewer such graphs than tropicalizations of classical plane curves. For fixed genus
g, our moduli space is a stacky fan whose cones are indexed by regular unimodular
triangulations of Newton polygons with g interior lattice points. It has dimension
2g + 1 unless g ≤ 3 or g = 7. We compute these spaces explicitly for g ≤ 5.

```
@Article{BJMS2015,
  author =  {Brodsky, Sarah and Joswig, Michael and Morrison, Ralph and Sturmfels, Bernd},
  title =   {Moduli of tropical plane curves},
  journal = {Res. Math. Sci.},
  volume =  {2},
  number =  {4},
  year =    {2015},
  doi =     {10.1186/s40687-014-0018-1},
}
```

## Forbidden patterns in tropical plane curves

Tropical curves in $R^2$ correspond to metric planar graphs but not all planar graphs
arise in this way. We describe several new classes of graphs which cannot occur.
For instance, this yields a full combinatorial characterization of the tropically planar
graphs of genus at most five.

```
@article{JT2020,
  author =  {Joswig, Michael and Tewari, Ayush Kumar},
  title =   {Forbidden patterns in tropical plane curves},
  JOURNAL = {Beitr\"age Algebra Geom.},
  year =    {2020},
  doi =     {10.1007/s13366-020-00523-6},
  note =    {Published online: 19 August 2020},
}
```

## Stacky fans and tropical moduli in polymake

We investigate geometric embeddings among several classes of stacky fans and algorithms, e.g., to compute their homology.
Interesting cases arise from moduli spaces of tropical curves.
Specifically, we study the embedding of the moduli of tropical honeycomb curves into the moduli of all tropical $K_4$-curves.

```
@Misc{BunnettJoswigPfeifle:2101.07316,
  author = {Bunnett, Dominic and Joswig, Michael and Pfeifle, Julian},
  title =  {Stacky fans and tropical moduli in polymake},
  year =   2021,
  note =   {Preprint arXiv:2101.07316}
}
```
