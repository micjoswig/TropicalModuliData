# This one defines the relevant variables for g=5 and Q3=conv{[2, 0], [4, 2], [2, 4], [0, 2]}

use application "polytope";

$Verbose::files=0;
#Core::XMLfile::suppress_validation($Scope); 

# genus
declare $genus=5;
# polytope name
declare $polytope="Q3"; # Sarah: D
# prefix for file names and working directory
declare $prefix="g$genus$polytope";
declare $wd_path="g$genus/secondary_fan";

# these are the points, homogeneous, linearly spanning
# as used by Sarah
declare $homogeneous_points=new Matrix([
[2,0,4], # 0
[1,1,4],
[0,2,4],
[2,1,3],
[1,2,3],
[3,1,2],
[2,2,2],
[1,3,2],
[3,2,1],
[2,3,1],
[4,2,0], # 10
[3,3,0],
[2,4,0]  # 12
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
declare $frame=new Set([0,10,12]);

# these points correspond to the cycles of the skeleton
declare $interior_lattice_points=new Array<Int>([3,4,6,8,9]);
declare %ilp_hash = ();
my $j=0; map { $ilp_hash{"$_"}=$j++ } @{$interior_lattice_points};

# group of lattice automorphisms preserving the point configuration
my $perm_action = new group::PermutationAction(GENERATORS=>[[0,5,10,3,8,1,6,11,4,9,2,7,12],[2,1,0,4,3,7,6,5,9,8,12,11,10]]);
declare $group=new group::Group(PERMUTATION_ACTION=>$perm_action);

# filenames with Sarah's data, relative to the Computations directory
declare $triangulations_file="g5/preprocessing/D/g5D_fine_regular_affine.txt";
declare $buckets_dir="g5/preprocessing/D/g5DBuckets";

# all buckets; precomputed by Sarah
declare @all_buckets=@{load_data("$wd_path/$prefix-buckets.dat")}; # {0 1 3 9 10 12 13 17 18 20 30 40 46 48 49 82 111 135 157 158}

# directory name for moduli, subdirectory in each bucket
declare $moduli_dir="moduli";

# names of the edges, should be 12
declare @skeleton_edge_names=qw(a b c d e f g h i j k l);
