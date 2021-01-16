# Brodsky, Joswig, Morrison & Sturmfels: Moduli of Plane Tropical Curves
# compute secondary cones; to be called from "Computations".

# prior to using do 'script "gXX/setupYY.pl";' to define the geometric data

use application "polytope";


print STDERR "secondary_cones g=$genus polytope=$polytope\n";
#die "secondary_cones: triangulation file $triangulations_file not found" unless -e $triangulations_file;

    my $S = new fan::SubdivisionOfPoints(POINTS=>$points, MAXIMAL_CELLS=>$cells);
    my $sec= $S->secondary_cone(lift_to_zero=>$frame);
    $sec->attach("ID","1");
    $sec->attach("POLYTOPE",$polytope);
    $sec->attach("GENUS",$genus);
    $sec->attach("TRIANGULAT",$cells);
    save $sec;



# Local Variables:
# mode: cperl
# c-basic-offset:2
# End:

