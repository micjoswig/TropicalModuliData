# Brodsky, Joswig, Morrison & Sturmfels: Moduli of Plane Tropical Curves
# computation of the moduli cones; to be called from "Computations".

use application "polytope";

# prior to using do 'script "gXX/setupYY.pl";' to define the geometric data
# ... and secondary_cones, standard_secondary_cones, skeleton

# return a hash which maps a primal edge to the index of the corresponding dual edge
sub primal_edge_hash($$) {
    my ($Sigma,$de_array)=@_;
    my %pe_hash;
    for (my $k=0; $k<$de_array->size(); ++$k) {
	my $de=$de_array->[$k];
	# intersect two triangles, yields primal edge as 2-element set
	my $pe=$Sigma->[$de->[0]]*$Sigma->[$de->[-1]];
    $pe = $pe->[0] . " " . $pe->[-1];
	$pe_hash{$pe}=$k;
    }
    return \%pe_hash;
}

# check if three points are collinear, in this ordering,
# i.e., check if b lies in the closed segment between a and c
sub ordered_collinear($$$) {
    my ($a,$b,$c)=@_;
    my ($a0_c0,$a1_c1)=($a->[0]-$c->[0],$a->[1]-$c->[1]);
    if ($a0_c0==0) {
	return undef if $b->[0]!=$a->[0];
	if ($a1_c1>0) {
	    return ($a->[1]>=$b->[1] && $b->[1]>=$c->[1]);
	} else {
	    return ($a->[1]<=$b->[1] && $b->[1]<=$c->[1]);
	}
    } elsif ($a1_c1==0) {
	return undef if $b->[1]!=$a->[1];
	if ($a0_c0>0) {
	    return ($a->[0]>=$b->[0] && $b->[0]>=$c->[0]);
	} else {
	    return ($a->[0]<=$b->[0] && $b->[0]<=$c->[0]);
	}
    } else {
	my $lambda=($b->[0]-$c->[0])/$a0_c0;
	my $mu=($b->[1]-$c->[1])/$a1_c1;
	return ($lambda==$mu && $lambda>=0 && $lambda<=1);
    }
}

sub moduli_one_cone($) {
  my ($c)=@_;
  my $id=$c->get_attachment("ID");
  my $b=$c->get_attachment("BUCKET");
  print STDERR " $id";

  my $n_rays=$c->N_RAYS;
  my $Sigma=$c->get_attachment("INDUCED_TRIANGULATION");
  my $de_array=$c->get_attachment("DUAL_EDGE_ARRAY");
  my $pe_hash=primal_edge_hash($Sigma,$de_array);
  my $de_skeleton_map=$c->get_attachment("DUAL_EDGE_SKELETON_MAP");
  my $n_skeleton_edges=$c->get_attachment("N_SKELETON_EDGES");
  my $moduli_matrix=new Matrix($n_rays,$n_skeleton_edges);

  for (my $r=0; $r<$n_rays; ++$r) {
    #print "\nmonomials:\n", $monomials, "\n";
    #print "ray: ", join (",", @{$c->RAYS->[$r]}), "\n"; 
    my $H=new tropical::Hypersurface<Min>(MONOMIALS=>$homogeneous_points,COEFFICIENTS=>$c->RAYS->[$r]); #Have to take homogenized monomials

#      my $coarsest=regular_subdivision($points,$c->RAYS->[$r]);
      my $standard_ray=$c->get_attachment("STANDARD_RAYS")->[$r];
      my @moduli_ray = map { new Rational(0) } 0..$n_skeleton_edges-1;
      my $rays_of_curve=$H->RAYS; # gibt dasselbe wie $H->VERTICES
      my $rays_vec = ray_inc($H->VERTICES);
      my $regions=$H->REGIONS;
      my $n_regions=$regions->rows();
      #print "no of regions: ", $n_regions, "\n";
      my $irredundant=new Array<Int>(sequence(0,$n)-$H->REDUNDANT_MONOMIALS); # maps REGIONS to MONOMIALS
      # iterate over the edges of the tropical curve
          foreach my $edge (@{$H->MAXIMAL_POLYTOPES}) {# irgendwie sowas wie dual graph von polyhedral complex
# ignore boundary edges of triangulation (dual to unbounded edges of curve)
            my $edge_vec = new Vector(map{$_==$edge->front || $_==$edge->back? 1: 0}(0..$rays_vec->dim-1));
            next if $rays_vec*$edge_vec>0; #next if edge is not a bounded edge
# find the two REGIONS containing the edge
              my $i=0;
              for ( ; (incl($regions->[$i],$edge)!=1)&&($i<$n_regions); ++$i) {}
              my $first_region=$i;
              for (++$i; (incl($regions->[$i],$edge)!=1)&&($i<$n_regions); ++$i) {}
              my $second_region=$i;
# take the MONOMIALS corresponding to the two REGIONS
              my ($i1,$i2)=($irredundant->[$first_region],$irredundant->[$second_region]);
              my ($m1,$m2)=($H->MONOMIALS->[$i1],$H->MONOMIALS->[$i2]);
# compute the lattice length of that edge
              my $le=gcd(primitive($m1-$m2));
# find corresponding dual edge
              my $de=${$pe_hash}{"$i1 $i2"};
              if (defined($de)) { # the $edge of the subdivision of the ray is an edge of the triangulation
                  my $se=$de_skeleton_map->[$de];
                  if ($se>=0) { # a skeleton edge, indeed
                      $moduli_ray[$se]+=$standard_ray->[$de]*$le;
                  }
              } else { # the $edge is a union of edges; find them
                  for (my $k=0; $k<$de_array->size(); ++$k) {
                      my $local_de=$de_array->[$k];
                      my $primal_edge=$Sigma->[$local_de->[0]]*$Sigma->[$local_de->[-1]];
                      my ($p,$q)=($monomials->[$primal_edge->[0]],$monomials->[$primal_edge->[-1]]);
                      if (ordered_collinear($m1,$p,$m2) && ordered_collinear($m1,$q,$m2)) { # found an edge of the triangulation
                          my $local_se=$de_skeleton_map->[$k];
                          if ($local_se>=0) { # a skeleton edge, indeed
                              $moduli_ray[$local_se]+=$standard_ray->[$k]*$le;
                          }
                      }
                  }
              }
          } # end edge
      $moduli_matrix->row($r)=new Vector(@moduli_ray);
  } # end ray
# pointed since all coordinates are non_negative; helps to avoid a small bug
    my ($red_moduli_matrix, $zero_row_idx_ref) = red_moduli_matrix($moduli_matrix);# kill zero rows of the $moduli_matrix
    if ($moduli_matrix == new Matrix($moduli_matrix->rows, $moduli_matrix->cols)){
        #print "moduli matrix zero\n";
        next;
    }

    my $moduli_cone=new Cone(INPUT_RAYS=>$red_moduli_matrix,POINTED=>1);
  my $mc_name=$c->name."-moduli";
  $moduli_cone->name=$mc_name;
  $moduli_cone->attach("ID",$id);
  $moduli_cone->attach("BUCKET",$b);
  $moduli_cone->attach("POLYTOPE",$polytope);
  $moduli_cone->attach("GENUS",$genus);
  $moduli_cone->attach("ZERO_ROW_IDX",join (", ", @{$zero_row_idx_ref}));
  my $schedule=$moduli_cone->get_schedule("CONE_DIM","RAYS","FACETS");
  $schedule->apply($moduli_cone);  # force computation of dimension etc
      save $moduli_cone, "$wd_path/$prefix"."b$b/$moduli_dir/$mc_name";
} # end cone

sub ray_inc{
    my $verts = $_[0];
    return ones_vector($verts->rows)-$verts->col(0);
}

sub red_moduli_matrix{
    my $matrix=$_[0];
    my @red_matrix = ();
    my @zero_row_idx = ();
    for (my $i=0; $i<$matrix->rows; ++$i){
        my $row = $matrix->row($i);
        if ($row!=new Vector($matrix->cols)){push @red_matrix, $row;}
        else{push @zero_row_idx, $i;}
    }
    my $red_matrix = new Matrix([@red_matrix]);
    return $red_matrix, \@zero_row_idx;
}


# main function, takes a list of buckets
sub moduli(@) {
  print STDERR "moduli g=$genus polytope=$polytope\n";
  foreach my $b (@_) {
    print STDERR "bucket $b";
    my $bprefix=$prefix."b$b";
    my $this_moduli_dir="$wd_path/$bprefix/$moduli_dir";
    if (! -d $this_moduli_dir) {
      mkdir $this_moduli_dir;
      print STDERR " [created $moduli_dir]";
    }
    print STDERR ", triangulations:";
    for my $id (@{load_data("$wd_path/$bprefix/$bprefix-ids.dat")}) {
      my $c=load("$wd_path/$bprefix/$bprefix-$id.cone");
        moduli_one_cone($c);
    }
    print STDERR "\n";
  }
}

# returns true if cone contains vector in its interior
sub cone_contains_vector($$) {
  my ($c,$v)=@_; # Cone<Scalar> and Vector<Scalar>
  my $contained=1;
  my $facets=$c->FACETS;
  my $n_facets=$facets->rows();
  for (my $i=0; $i<$n_facets; ++$i) {
    if ($v * $facets->[$i] <= 0) {
      $contained=0; last;
    }
  }
  if ($contained) {
    my $equations=$c->LINEAR_SPAN;
    my $n_equations=$equations->rows();
    for (my $i=0; $i<$n_equations; ++$i) {
      if ($v * $equations->[$i] != 0) {
	$contained=0; last;
      }
    }
  }
  return $contained;
}

# list all moduli cones which contain a given moduli vector in their interior
# FIXME: does not take symmetry into account yet
sub cones_with_given_moduli($) {
  my ($moduli)=@_; # vector-like
  $moduli=new Vector($moduli);
  my $total=0;
  my $total_cones=0;
  for my $b (@all_buckets) {
    print STDERR "bucket $b:";
    my $btotal=0;
    my $bprefix=$prefix."b$b";
    my $all_ids=load_data("$wd_path/$bprefix/$bprefix-ids.dat");
    my $n_all_ids=$all_ids->size();
    for my $id (@$all_ids) {
      my $m=load("$wd_path/$bprefix/moduli/$bprefix-$id-moduli.cone");
      # FIXME: iterate over entire orbit minstead of checking one vector
      if (cone_contains_vector($m,$moduli)) {
	print STDERR " $id";
	++$btotal;
      }
    }
    print STDERR " btotal=$btotal/$n_all_ids\n";
    $total+=$btotal;
    $total_cones+=$n_all_ids;
  }
  print "total=$total/$total_cones\n";
}

# Local Variables:
# mode: cperl
# c-basic-offset:2
# End:
