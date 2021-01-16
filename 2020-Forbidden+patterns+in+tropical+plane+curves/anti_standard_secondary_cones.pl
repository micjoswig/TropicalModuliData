
# prior to using do 'script "gXX/setupYY.pl";' to define the geometric data
# ... and secondary_cones

use application "polytope";

# prior to using do something like 'script "setup.pl";'
# to define the geometric data
# assumes that results from secondary_cones.pl are available

sub standardize($$$$) {
  my ($A,$Sigma,$dual_edges,$v)=@_;
  # Matrix: point configuration
  # Array<Set>: subdivision
  # Array<Set>: dual edges
  # Vector: in the secondary fan of $Sigma
  # returns Vector of dual heights
  my $AA=$A|$v; # lifted points
  my $n_dual_edges=$dual_edges->size();
  my $dual_heights=new Vector($n_dual_edges);
  for (my $i=0; $i<$n_dual_edges; ++$i) {
    my ($first,$second)=@{$dual_edges->[$i]};
    $dual_heights->[$i]=abs(det($AA->minor( $Sigma->[$first]+$Sigma->[$second], All )));
  }
  return $dual_heights;
}    

sub standard_one_cone($) {
  my ($c)=@_;
  my $id=$c->get_attachment("ID");
  print STDERR " $id";
  my $Sigma=$c->get_attachment("TRIANGULAT");
  my $Sigma_pc=new fan::SubdivisionOfPoints(POINTS=>$points,MAXIMAL_CELLS=>$Sigma);
  my $dual_edges=new Array<Set>($Sigma_pc->TIGHT_SPAN->GRAPH->EDGES);
  my $new_rays=primitive(new Matrix(map { standardize($points,$Sigma,$dual_edges,$_) } @{rows($c->RAYS)}));
  $c->attach("DUAL_EDGE_ARRAY",$dual_edges);
  $c->attach("STANDARD_RAYS",$new_rays);
  save $c;
}

sub standard_secondary_cones(@) {
  print STDERR "standard_secondary_cones g=$genus polytope=$polytope\n";
      my $c=load("g$genus.cone");
      standard_one_cone($c);
    print STDERR "\n";
}

# Local Variables:
# mode: cperl
# c-basic-offset:2
# End:
