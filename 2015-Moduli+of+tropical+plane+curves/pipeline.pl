# Brodsky, Joswig, Morrison & Sturmfels: Moduli of Plane Tropical Curves

script "standard_secondary_cones.pl";
script "skeleton.pl";
script "moduli.pl";
script "tools.pl";

# requires setup and bucket files
# secondary_cones.pl must be called separately and before

sub pipeline(@) {
  print STDERR "pipeline g=$genus polytope=$polytope\n";
  foreach my $b (@_) {
    standard_secondary_cones($b);
    skeleton($b);
    moduli($b);
  }
}

# Local Variables:
# mode: cperl
# c-basic-offset:2
# End:
