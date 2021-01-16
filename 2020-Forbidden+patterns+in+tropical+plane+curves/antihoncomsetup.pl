# This one defines the relevant variables for g=19, anti-honeycomb triangulation.

use application "polytope";

Core::XMLfile::suppress_validation($Scope); 
$Verbose::files=0;

# genus
declare $genus=19;
# polytope name
declare $polytope="T_{k=4}";
# prefix for file names and working directory
declare $prefix="g$genus$polytope";
declare $wd_path="g$genus/secondary_fan";

# these are the points, homogeneous, linearly spanning
declare $homogeneous_points=new Matrix([
[8,0,0],
[7,1,0],
[7,0,1],
[10,-1,-1],
[9,-1,0],
[9,0,-1],
[6,1,1],
[10,-2,0],
[10,0,-2],
[4,2,2],
[6,2,0],
[7,2,-1],
[4,3,1],
[8,1,-1],
[5,3,0],
[4,4,0], #15
[5,2,1],
[6,0,2],
[7,-1,2],
[4,1,3],
[8,-1,1],
[5,0,3],
[4,0,4], #22
[5,1,2],
[12,-2,-2],
[13,-3,-2],
[13,-2,-3],
[11,-1,-2],
[11,-2,-1],
[14,-3,-3],
[16,-4,-4] #30
]);
# number of points
declare $n=$homogeneous_points->rows();

# this is how polymake needs those points for most operations
declare $monomials=$homogeneous_points->minor(All,[1,2]);
declare $points=new Matrix(ones_vector($n)|$monomials);
# need to hash the monomials
declare %monomial_hash = ();
my $i=0; map { $monomial_hash{"$_"}=$i++ } @{rows($monomials)};

# these points will be set to zero
declare $frame=new Set([15,22,30]);

# these points correspond to the cycles of the skeleton
declare $interior_lattice_points=new Array<Int>([0,1,2,3,4,5,6,10,13,14,16,17,20,21,23,24,27,28,29]);
declare %ilp_hash = ();
my $j=0; map { $ilp_hash{"$_"}=$j++ } @{$interior_lattice_points};


declare $cells = new Array<Set<Int>>([
[0,1,2], [0,2,3], [0,1,3],
[1,2,6], [1,6,9], [2,6,9],
[2,3,4], [2,4,7], [3,4,7],
[1,3,5], [1,5,8], [3,5,8],
#
[1,10,11], [1,10,12], [10,11,12],
[1,8,13], [1,11,13], [8,11,13],
[11,12,14], [11,14,15], [12,14,15],
[1,9,16], [1,12,16], [9,12,16],
#
[2,17,18], [2,17,19], [17,18,19],
[18,19,21], [18,21,22], [19,21,22],
[2,7,20], [2,18,20], [7,18,20],
[2,9,23], [2,19,23], [9,19,23],
#
[3,24,25], [3,24,26], [24,25,26],
[3,8,27], [3,26,27], [8,26,27],
[3,7,28], [3,25,28], [7,25,28],
[25,26,29], [25,29,30], [26,29,30]
]);


# group of lattice automorphisms preserving the point configuration
#my $g=new group::PermutationAction(GENERATORS=>[[5,6,7,8,9,0,1,2,3,4,10,12,11,13,14],[10,11,12,13,14,5,7,6,8,9,0,1,2,3,4]]);
#declare $group= new group::Group(PERMUTATION_ACTION=>$g);

# filenames with Sarah's data, relative to the Computations directory
#declare $triangulations_file="g3/preprocessing/g3TriangulationsData/g3FineRegularAffine.txt";
#declare $buckets_dir="g3/preprocessing/g3Buckets";

# all buckets; precomputed by Sarah
#declare @all_buckets=@{load_data("$wd_path/$prefix-buckets.dat")}; # one_bridge mickey_mouse honeycomb two_bridge

# directory name for moduli, subdirectory in each bucket
declare $moduli_dir="moduli";

# names of the edges
declare @skeleton_edge_names=qw(a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 a12 a13 a14 a15 a16 a17 a18 a19 a20 a21 a22 a23 a24 a25 a26 a27 a28 a29 a30 a31 a32 a33 a34 a35 a36 a37 a38 a39 a40 a41 a42 a43 a44 a45 a46 a47 a48 a49 a50 a51 a52 a53 a54);
