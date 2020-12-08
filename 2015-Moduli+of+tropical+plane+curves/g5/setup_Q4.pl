# This one defines the relevant variables for g=5 and Q4=conv{[0, 0], [0, 2], [2, 0], [4, 4]}

use application "polytope";

$Verbose::files=0;
#Core::XMLfile::suppress_validation($Scope); 

# genus
declare $genus=5;
# polytope name
declare $polytope="Q4"; # Sarah: A
# prefix for file names and working directory
declare $prefix="g$genus$polytope";
declare $wd_path="g$genus/secondary_fan";

# these are the points, homogeneous, linearly spanning
# as used by Sarah
declare $homogeneous_points=new Matrix([
[0,0,8], #0
[1,0,7],
[0,1,7],
[2,0,6], #3
[1,1,6],
[0,2,6],
[2,1,5],
[1,2,5],
[2,2,4],
[3,2,3],
[2,3,3],
[3,3,2],
[4,4,0] #12
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
declare $frame=new Set([0,3,12]);

# these points correspond to the cycles of the skeleton
declare $interior_lattice_points=new Array<Int>([4,6,7,8,11]);
declare %ilp_hash = ();
my $j=0; map { $ilp_hash{"$_"}=$j++ } @{$interior_lattice_points};

# group of lattice automorphisms preserving the point configuration
my $perm_action = new group::PermutationAction(GENERATORS=>[[0,2,1,5,4,3,7,6,8,10,9,11,12]]);
declare $group=new group::Group(PERMUTATION_ACTION=>$perm_action);

# filenames with Sarah's data, relative to the Computations directory
declare $triangulations_file="g5/preprocessing/A/g5A_fine_regular_affine.txt";
declare $buckets_dir="g5/preprocessing/A/g5ABuckets";

# all buckets; precomputed by Sarah
declare @all_buckets=@{load_data("$wd_path/$prefix-buckets.dat")}; # qw(0 1 2 9 10 12 20 37 70 91 93 116 137 173 226 321 328 329 359 372 421 465 564 568 579 687 760 770 811 865 871 883 943 950 966);

# directory name for moduli, subdirectory in each bucket
declare $moduli_dir="moduli";

# names of the edges, should be 12
declare @skeleton_edge_names=qw(a b c d e f g h i j k l);
