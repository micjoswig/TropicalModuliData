# Moduli of tropical plane curves

This is the software companion to the paper:

[1] Brodsky, Joswig, Morrison & Sturmfels:
Moduli of Plane Tropical Curves, Research in the Mathematical Sciences (2015).
[DOI: 10.1186/s40687-014-0018-1}(https://link.springer.com/article/10.1186/s40687-014-0018-1)

This [polymake](https://www.polymake.org) code processes triangulation data which was computed by [TOPCOM](http://www.rambau.wm.uni-bayreuth.de/TOPCOM/) or [MPTOPCOM](https://polymake.org/doku.php/mptopcom).

Everything has been tested with [polymake 4.2](https://polymake.org/doku.php/news/release_4_2) of September 2020.

Original code written in 2015 by [Michael Joswig](http://page.math.tu-berlin.de/~joswig/); TOPCOM data and additions by Sarah Brodsky, Further additions and data conversion in 2020 by [Holger Eble](http://page.math.tu-berlin.de/~eble/) and [Ayush Kumar Tewari](https://sites.google.com/view/ayushkumartewari/home).

## How to use the polymake scripts

You need to change to the directory `2015-Moduli+of+tropical+plane+curves`, start polymake and initiate the setup.
Look at the `intro.ipynb` for details.


## Organization of the files

For each genus there is one subdirectory, below `Computations`.  This
in turn contains the subdirectories

* `preprocessing`: results obtained via TOPCOM and polymake
* `secondary_fan`: the bulk of the polymake computations and the final results

Among other things the `secondary_fan` subdirectory contains one
directory per polytope and bucket.  E.g., `g3b7` for the honeycomb
basket for $g=3$ (no polytope here, as there is only one) or `g4T1b0`
for the $g=4$ basket with number #0 with respect to the polytope T1.


## Setting up new experiments

Form a new folder for each genus.  E.g., for $g=5$ you create `g5`.
There create a file `setup.pl`.  To this end copy from `g3/setup.pl` and
edit.  If you have several polygons, you create one setup file for
each of them.  The convention is to invent a name for the polygon,
like `hyp`, which appears as part of the file and directory names
associated.

Then create the file with the list of buckets, e.g., `g3/secondary_cones/g3-buckets.dat`

Sequence of scripts (after setup; see above):
  `secondary_cones`, `standard_secondary_cones`, `skeleton`, `moduli`
The latter three are summarized in `pipeline`.

This is the whole process.  You start with

* `script secondary_cones.pl;`

to produce all secondary cones from TOPCOM like data (but not in standard form).  Afterwards do

* `script pipeline.pl;`

and call

* `pipeline(@all_buckets);`

to do the whole computation.  However, this can take for a while.
Therefore, instead you might want to call pipeline for only one or two
buckets.  Or, for paralleilzation, you could even call the functions
`standard_secondary_cones`, `skeleton` and `moduli` individually, one after the other.

Proceed as above.

NOTE: The triangulations must be computed before, by TOPCOM or MPTOPCOM.


## How to read the skeleton file

This resides at `$wd_path/$bprefix/$bprefix-skeleton.dat`.  The global variables `$wd_path` and `$bprefix` are defined in the setup.

Lets say the genus we are working with is n. For each combinatorial type, there is a file, located under ~/Smooth+Tropical+Curves+in+the+Plane/Computations/gn/secondary_fan/gn<name of bucket>, called gn<name of bucket>-skeleton.dat containing the information on how to label the edges of graphs of that type.
Let’s learn how to read the files `gn<name of bucket>-skeleton.dat` by example. Let's consider the $g=3$ skeleton for bucket 0. Opening up the file `g3b0-skeleton.dat`, we see the following:

```
    <v>0 1 2</v>
    <v>0 1 3</v>
    <v>2 3 4</v>
    <v>4 5</v>
    <v>0 1</v>
    <v>1 2 3</v>
    <v>5</v>
```

The first four rows represent the $2g-2=2 \cdot 3-2=4$ vertices of a given graph of this combinatorial type. The remaining three rows represent the three “holes” of a given graph of this combinatorial type. 

The numbers in the first 4 rows are labels of the $3g-3=3 \cdot 3-3=6$ edges of a given graph of this combinatorial type, and where they appear tells us which vertices are their endpoints. For instance, 0 appears in the 0th row and the 1st row. So 0 represents the edge connecting vertex 0 and vertex 1. We can also see that 2 appears in 0th and 2nd rows, so 2 represents the edge connecting vertex 0 and vertex 2. We can also see that edge 5 only appears in row 3, meaning that 5 represents the edge connecting vertex 3 to itself. 

The numbers in the last 3 rows are labels of the edges enclosing each region. In our example, the 4th row represents the region enclosed by the edges 0 and 1, the 5th row represents the region enclosed by edges 1, 2, and 3, and the 6th row represents the region enclosed by the edge 5.
