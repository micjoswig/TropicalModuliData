# This one defines the relevant variables for g=3, non-hyperelliptic case.

use application "polytope";

#Core::XMLfile::suppress_validation($Scope); 
$Verbose::files=0;

# genus
declare $genus=3;
# polytope name
declare $polytope="";
# prefix for file names and working directory
declare $prefix="g$genus$polytope";
declare $wd_path="g$genus/secondary_fan";

# these are the points, homogeneous, linearly spanning
# as used by Sarah
declare $homogeneous_points=new Matrix([
[0,0,4], #0
[1,0,3],
[0,1,3],
[2,0,2],
[1,1,2],
[0,2,2],
[3,0,1],
[2,1,1],
[1,2,1],
[0,3,1],
[4,0,0], #10
[3,1,0],
[2,2,0],
[1,3,0],
[0,4,0]  #14
]);

# number of points
declare $n=$homogeneous_points->rows();

# this is how polymake needs those points for most operations
declare $monomials=$homogeneous_points->minor(All,[0,1]);
declare $points=new Matrix(ones_vector($n)|$monomials);
# need to hash the monomials
declare %monomial_hash = ();
my $i=0; map { $monomial_hash{"$_"}=$i++ } @{rows($monomials)};

# these points will be set to zero
declare $frame=new Set([0,10,14]);

# these points correspond to the cycles of the skeleton
declare $interior_lattice_points=new Array<Int>([4,7,8]);
declare %ilp_hash = ();
my $j=0; map { $ilp_hash{"$_"}=$j++ } @{$interior_lattice_points};

# group of lattice automorphisms preserving the point configuration
my $g=new group::PermutationAction(GENERATORS=>[[5,6,7,8,9,0,1,2,3,4,10,12,11,13,14],[10,11,12,13,14,5,7,6,8,9,0,1,2,3,4]]);
declare $group= new group::Group(PERMUTATION_ACTION=>$g);

# filenames with Sarah's data, relative to the Computations directory
declare $triangulations_file="g3/preprocessing/g3TriangulationsData/g3FineRegularAffine.txt";
declare $buckets_dir="g3/preprocessing/g3Buckets";

# all buckets; precomputed by Sarah
declare @all_buckets=@{load_data("$wd_path/$prefix-buckets.dat")}; # one_bridge mickey_mouse honeycomb two_bridge

# directory name for moduli, subdirectory in each bucket
declare $moduli_dir="moduli";

# names of the edges
declare @skeleton_edge_names=qw(u v w x y z);
