use Benchmark qw(:all);
$t0 = Benchmark->new;

application "tropical";

($u, $v, $w, $x, $y, $z) = 0..5;
$skeleton = new IncidenceMatrix(
                [[$u,$v,$x],[$v,$w,$z],[$u,$w,$y],[$x,$y,$z]]);
$TG_K4 = new tropical::Curve(EDGES_THROUGH_VERTICES=>$skeleton);

print stacky_fan($TG_K4)->STACKY_F_VECTOR;

$moduli_k4 = $TG_K4->MODULI_CELL;
print $moduli_k4->HOMOLOGY;

print $moduli_k4->F_VECTOR;

($U,$V,$W,$X,$Y,$Z) =
  map { new Vector($_ ) } @{rows(unit_matrix(6))};
$D_ineqs = new Matrix([$U-$X, $U-$Y, $V-$X, $V-$Z, $W-$Y, $W-$Z]);
$TK4_planar = new Curve(
  EDGES_THROUGH_VERTICES=>$skeleton, INEQUALITIES=>$D_ineqs);

print stacky_fan($TK4_planar)->STACKY_F_VECTOR;

$mod_honey = $TK4_planar->MODULI_CELL;
print $mod_honey->F_VECTOR;

print $mod_honey->HOMOLOGY;

print topaz::random_discrete_morse($mod_honey,rounds=>1);

$t1 = Benchmark->new;
$td1=timediff($t1,$t0);
print "total time ", timestr($td1);
