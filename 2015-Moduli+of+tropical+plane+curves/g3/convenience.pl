script "g3/setup_hyp.pl";
script "tools.pl";
$c=secondary_cone_by_id(10,3104);
$m=moduli_cone_by_id(10,3104);
print $m->DIM;
$C=curve($c);
jreality($C->VISUAL);
print rows_numbered($C->MONOMIALS);
print numbered($C->COEFFICIENTS);
print primitive($m->REL_INT_POINT);
for my $id (2919, 2938, 3018, 3019, 3020, 3072, 3073, 3088, 3089, 3094, 3096, 3099, 3101, 3102, 3103, 3104) { $m=moduli_cone_by_id(10,$id); print "id=$id ", primitive($m->REL_INT_POINT), "\n"; }
