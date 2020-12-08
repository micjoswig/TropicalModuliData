# This one defines the relevant variables for g=3; hyperellipitic Triangle case.

use application "polytope";

#Core::XMLfile::suppress_validation($Scope); 
$Verbose::files=0;

# genus
declare $genus=3;
# polytope name
declare $polytope="hyptri";
# prefix for file names and working directory
declare $prefix="g$genus$polytope";
declare $wd_path="g$genus/secondary_fan";

# these are the points, homogeneous, linearly spanning
# as used by Sarah
declare $homogeneous_points=new Matrix([
[0,0,8], #0
[1,0,7],
[2,0,6],
[3,0,5],
[4,0,4],
[5,0,3],
[6,0,2],
[7,0,1],
[8,0,0], #8
[0,1,7],
[1,1,6],
[2,1,5],
[3,1,4],
[4,1,3],
[0,2,6] #14
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
declare $frame=new Set([0,8,14]);

# these points correspond to the cycles of the skeleton
declare $interior_lattice_points=new Array<Int>([10,11,12]);
declare %ilp_hash = ();
my $i=0; map { $ilp_hash{"$_"}=$i++ } @{$interior_lattice_points};

# filenames with Sarah's data, relative to the Computations directory
declare $triangulations_file="g3/preprocessing/g3hyptri/g3hyptri_fine_regular_affine.txt";
declare $buckets_dir="g3/preprocessing/g3hyptri/g3hyptriBuckets";

# all buckets; precomputed by Sarah
declare @all_buckets=@{load_data("$wd_path/$prefix-buckets.dat")}; # qw (0 1 10)

# directory name for moduli, subdirectory in each bucket
declare $moduli_dir="moduli";

# names of the edges
declare @skeleton_edge_names=qw(u v w x y z);
