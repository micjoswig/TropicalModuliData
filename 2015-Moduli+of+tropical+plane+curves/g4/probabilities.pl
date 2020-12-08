# Brodsky, Joswig, Morrison & Sturmfels: Moduli of Plane Tropical Curves
# various tools geared towards combining the moduli space from several polytopes

# prior to using do 'script "g4/setupR.pl";' to define the geometric data
# ... and secondary_cones, standard_secondary_cones, skeleton, moduli

use application "polytope";

# genus 4: polytope=R only, 5 buckets with 9-dim moduli space
# (000)A = 100, (010) = 48, (020) = 9, (021) = 42, (030) = 273
declare @bigbuckets=(100,48,9,42,273);

my $verbose=1;

die "This only works for genus 3 and 4!" unless $genus==3 || $genus==4;

sub probabilities(@) {
  my $n=shift(@_); # number of points to test, remaining arguments are bucket numbers

  my $d=3*$genus-3; # dimension of moduli space (for g=3,4)
  my $n_nodes=2*($genus-1); # number of nodes of the skeleton

  # take a standard simplex ...
  my $S=new Polytope(VERTICES=>(ones_vector<Rational>($d))|(unit_matrix<Rational>($d)),LINEALITY_SPACE=>[]);
  # ... and sample uniformly at random
  my $R=rand_inner_points($S,$n);

  print STDERR "probabilities: g=$genus n=$n buckets=[@_]\n";

  # preprocess by listing the moduli cones of maximal dimension,
  # paired with the automorphism groups of the respective skeleton
  my @bigcones=();
  my %groups=();
  foreach my $b (@_) {
    my $bprefix=$prefix."b$b";
    my $all_ids=load_data("$wd_path/$bprefix/$bprefix-bigids.dat");
    my $skeleton=load_data("$wd_path/$bprefix/$bprefix-skeleton.dat");
    my $restricted_skeleton=$skeleton->minor(sequence(0,$n_nodes),All);
    my $group_pair=automorphisms($restricted_skeleton);
    my @gens = map { $_->second() } @$group_pair;
    my $g=new group::Group(GENERATORS=>\@gens);
    $groups{$b}=$g;
    foreach my $id (@$all_ids) {
      my $m=load("$wd_path/$bprefix/moduli/$bprefix-$id-moduli.cone");
      if ($m->CONE_DIM==$d) {
	push @bigcones, $m;
      }
    }
  }

  print STDERR "preprocessing done: ", scalar(@bigcones), " cones to query\n" if $verbose;

  my $cnt=0;
  for (my $i=0; $i<$n; ++$i) {
    # notice that the random point has the leading 1 for homogenization ...
    my $random_vector=$R->POINTS->[$i];
    # does there exist a cone which contains this vector up to symmetry?
    my $found=0;
    my %orbits=();
    foreach my $b (@_) {
      my $g=$groups{$b};
      # ... this fits the current implementation of the following
      my ($orbit,$to_be_ignored)=group::orbits_coord_action_complete($g,new Matrix([$random_vector]));
      $orbits{$b}=$orbit;
    }
    for (my $k=0; !$found && $k<=$#bigcones; ++$k) {
      my $m=$bigcones[$k];
      my $b=$m->get_attachment("BUCKET");
      my @orbit=@{$orbits{$b}}; # sorry for this brutal naming of variables
      foreach my $v (@orbit) {
	my $vv=$v->slice(1); # now we need to get rid off that 1 again
	if (cone_contains_vector($m,$vv)) {
	  my $id=$m->get_attachment("ID");
	  ++$cnt;
	  my $probability=convert_to<Float>(new Rational($cnt,$i+1));
	  print STDERR "[vec=$i b=$b id=$id orbitsize=", scalar(@orbit), " $probability] " if $verbose;
	  $found=1; last; # one cone suffices
	}
      }
    }
  }

  my $probability=convert_to<Float>(new Rational($cnt,$n));
  print "\ng$genus$polytope: b=[@_] cnt=$cnt probability=$probability\n" if $verbose;
  return $cnt;
}


# Local Variables:
# mode: cperl
# c-basic-offset:2
# End:
