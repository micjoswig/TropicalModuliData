# Brodsky, Joswig, Morrison & Sturmfels: Moduli of Plane Tropical Curves
# various tools

# prior to using do 'script "gXX/setupYY.pl";' to define the geometric data
# ... and secondary_cones, standard_secondary_cones, skeleton, moduli

use application "polytope";

# prior to using do something like 'script "*/setup.pl";' to define the geometric data
# assumes that results from the following scripts are available:
# standard_secondary_cones.pl, skeleton.pl, moduli.pl

# CONES

sub secondary_cone_by_id($$) {
  my ($b,$id)=@_; # bucket and id
  my $bprefix=$prefix."b$b";
  return load("$wd_path/$bprefix/$bprefix-$id.cone");
}

sub moduli_cone_by_id($$) {
  my ($b,$id)=@_; # bucket and id
  my $bprefix=$prefix."b$b";
  return load("$wd_path/$bprefix/moduli/$bprefix-$id-moduli.cone");
}

# CURVE

# return one smooth curve corresponding to a triangulation
sub curve($) {
  my ($c)=@_; # secondary cone object
  my $h=primitive($c->REL_INT_POINT);
  my $C=new tropical::Hypersurface(MONOMIALS=>$monomials,COEFFICIENTS=>$h);
  return $C;
}

# SKELETON

# return (l,b,c), where is the number of loops, b is the number of bi-edges, and c is the number of cut edges
sub skeleton_type($) {
  my ($skeleton)=@_; # IncidenceMatrix, as in *-skeleton.dat
  my $n_nodes=2*($genus-1);
  my $n_edges=$n_nodes+$genus-1;
  my $n_rows=$skeleton->rows();
  my $n_cols=$skeleton->cols();
  die "skeleton_type: number of nodes/regions $n_rows does not match genus $genus\n" unless $n_nodes+$genus==$n_rows;
  die "skeleton_type: number of edges $n_cols does not match genus $genus\n" unless $n_edges==$n_cols;
  my $loops=0;
  my $bi_edges=0;
  my $all_regions=range($n_nodes,$n_rows-1);
  foreach my $region (@$all_regions) {
    ++$loops if $skeleton->row($region)->size()==1;
    ++$bi_edges if $skeleton->row($region)->size()==2;
  }
  my $cut_edges=0;
  for (my $edge=0; $edge<$n_edges; ++$edge) {
    ++$cut_edges if ($skeleton->col($edge) * $all_regions)->size()==0;
  }
  return new Array<Int>([$loops,$bi_edges,$cut_edges]);
}

# return barycenter of a triangle
sub barycenter($) {
  my ($triangle)=@_; # Set
  my ($a,$b,$c)=@{rows($points->minor($triangle,All))};
  return 1/3*($a+$b+$c);
}

# return objects for triangulation and skeleton, e.g., for visualization
sub skeleton_objects($) {
  my ($c)=@_; # secondary cone, including skeleton related attachments
  my $Sigma=$c->get_attachment("INDUCED_TRIANGULATION");
  my $Sigma_pc=new fan::PolyhedralComplex(POINTS=>$points,MAXIMAL_CELLS=>$Sigma);
  my @all_barycenters = map { barycenter($_) } @$Sigma;
  my $de_array=$c->get_attachment("DUAL_EDGE_ARRAY");
  my $de_map=$c->get_attachment("DUAL_EDGE_SKELETON_MAP");
  my $n_skeleton_edges=$c->get_attachment("N_SKELETON_EDGES");
  my @paths = map { new Set<Set>() } 0..($n_skeleton_edges-1);
  for (my $e=0; $e<$de_array->size(); ++$e) {
    my $se=$de_map->[$e];
    if ($se>=0) {
      $paths[$se] += $de_array->[$e];
    }
  }
  my @big_objects = map { my $edge=new fan::PolyhedralComplex(POINTS=>\@all_barycenters,
							      MAXIMAL_CELLS=>$paths[$_]);
			  $edge->name=$skeleton_edge_names[$_];
			  $edge; } 0..($n_skeleton_edges-1);
  unshift @big_objects, $Sigma_pc;
  return \@big_objects;
}


# automorphism group of skeleton, acting on the edges
sub skeleton_group_acting_on_edges($) {
  my ($b)=@_; # Int: bucket
  my $bprefix=$prefix."b$b";
  my $skeleton=load_data("$wd_path/$bprefix/$bprefix-skeleton.dat");
  my $Aut=automorphisms($skeleton);
  my $generators = new Array<Array<Int>>( map { $_->second() } @$Aut );
  return new group::Group(GENERATORS=>$generators);
}


# STATISTICS

sub moduli_statistics(;$) {
  my ($verbose)=@_; # Bool
  print "moduli_statistics g=$genus polytope=$polytope #buckets=", scalar(@all_buckets), "\n";
  my $total=0;
  my $n=0;
  my @dimensions=();
  for my $b (@all_buckets) {
    my $bprefix=$prefix."b$b";
    my $bucket_ids_file="$wd_path/$bprefix/$bprefix-ids.dat";
    my $bucket_skeleton_file="$wd_path/$bprefix/$bprefix-skeleton.dat";
    my $bucket_ids;
    eval { $bucket_ids=load_data($bucket_ids_file) };
    die "$bucket_ids_file not found" if $@;
    my $bucket_size=$bucket_ids->size();
    my $btotal=0;
    my @bucket_dimensions=();
    print "bucket $b [", skeleton_type(load_data($bucket_skeleton_file)), "]:";
    for my $id (@$bucket_ids) {
      if (-e "$wd_path/$bprefix/$bprefix-$id.cone") {
	my $m_name="$wd_path/$bprefix/moduli/$bprefix-$id-moduli.cone";
	if (-e $m_name) {
	  my $m=load($m_name);
	  push @bucket_dimensions, $m->CONE_DIM;
	  ++$btotal;
	} else {
	  print " m$id" if $verbose;
	}
      } else {
	print " s$id" if $verbose;
      }
    }
    print " dims=", histogram(\@bucket_dimensions), " $btotal/$bucket_size\n";
    $total+=$btotal;
    $n+=$bucket_size;
    push @dimensions,@bucket_dimensions;
  }
  print "TOTAL: dims=", histogram(\@dimensions), " $total/$n\n";
}


# Local Variables:
# mode: cperl
# c-basic-offset:2
# End:
