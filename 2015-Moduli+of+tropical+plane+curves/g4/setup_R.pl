# This one defines the relevant variables for g=4 and R=4x4-square.

use application "polytope";

$Verbose::files=0;
#Core::XMLfile::suppress_validation($Scope); 

# genus
declare $genus=4;
# polytope name
declare $polytope="R";
# prefix for file names and working directory
declare $prefix="g$genus$polytope";
declare $wd_path="g$genus/secondary_fan";

# these are the points, homogeneous, linearly spanning
# as used by Sarah
declare $homogeneous_points=new Matrix([
[0,0,6], # 0
[1,0,5],
[0,1,5],
[2,0,4],
[1,1,4],   # 4
[0,2,4],
[3,0,3], # 6
[2,1,3],   # 7
[1,2,3],   # 8
[0,3,3],
[3,1,2],
[2,2,2],   # 11
[1,3,2],
[3,2,1],
[2,3,1],
[3,3,0] # 15
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
declare $frame=new Set([0,6,15]);

# these points correspond to the cycles of the skeleton
declare $interior_lattice_points=new Array<Int>([4,7,8,11]);
declare %ilp_hash = ();
my $j=0; map { $ilp_hash{"$_"}=$j++ } @{$interior_lattice_points};

# group of lattice automorphisms preserving the point configuration
my $perm_action=new group::PermutationAction(GENERATORS=>[[0,2,1,5,4,3,9,8,7,6,12,11,10,14,13,15],[6,3,10,1,7,13,0,4,11,15,2,8,14,5,12,9],[15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0]]);
declare $group = new group::Group(PERMUTATION_ACTION=>$perm_action);

# filenames with Sarah's data, relative to the Computations directory
declare $triangulations_file="g4/preprocessing/4x4Square/g4S4x4TriangulationsData/g4S4x4FineRegularAffine.txt";
declare $buckets_dir="g4/preprocessing/4x4Square/g4S4x4Buckets";

# all buckets; precomputed by Sarah
declare @all_buckets=@{load_data("$wd_path/$prefix-buckets.dat")}; # qw(0 3 4 9 11 12 42 48 100 139 273 534);

# directory name for moduli, subdirectory in each bucket
declare $moduli_dir="moduli";

# names of the edges, should be 9
declare @skeleton_edge_names=qw(a b c d e f g h i);
