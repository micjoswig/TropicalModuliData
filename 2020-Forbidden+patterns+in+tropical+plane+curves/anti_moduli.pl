

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
  my $b="1";
  print STDERR " $id";

  my $n_rays=$c->N_RAYS;
  my $Sigma=$c->get_attachment("TRIANGULAT");
  my $de_array=$c->get_attachment("DUAL_EDGE_ARRAY");
  my $pe_hash=primal_edge_hash($Sigma,$de_array);
  my $de_skeleton_map=$c->get_attachment("DUAL_EDGE_SKELETON_MAP");
  my $n_skeleton_edges=$c->get_attachment("N_SKELETON_EDGES");
  my $moduli_matrix1=new Matrix($n_rays,$n_skeleton_edges);
  my @zero = map { new Rational(0) } 0..$n_skeleton_edges-1;
  my $f=0;
  my $z= new Vector(@zero);
  
  for (my $r=0; $r<$n_rays; ++$r) {
      my $H=new tropical::Hypersurface<Min>(MONOMIALS=>$homogeneous_points,COEFFICIENTS=>$c->RAYS->[$r]);
#      my $coarsest=regular_subdivision($points,$c->RAYS->[$r]);
      my $standard_ray=$c->get_attachment("STANDARD_RAYS")->[$r];
      my @moduli_ray = map { new Rational(0) } 0..$n_skeleton_edges-1;
      my $rays_of_curve=$H->FAR_VERTICES;
      my $regions=$H->REGIONS;
      my $n_regions=$regions->rows();
      my $irredundant=new Array<Int>(sequence(0,$n)-$H->REDUNDANT_MONOMIALS); # maps REGIONS to MONOMIALS

      # iterate over the edges of the tropical curve
      foreach my $edge (@{$H->MAXIMAL_POLYTOPES}) {
          #print $edge;
          #print "\n";
          #print $rays_of_curve;
	  # ignore boundary edges of triangulation (dual to unbounded edges of curve)
	  next if (($edge*$rays_of_curve)->size()>0);
          #print $edge;
	  # find the two REGIONS containing the edge
	  my $i=0;
	  for ( ; (incl($regions->[$i],$edge)!=1)&&($i<$n_regions); ++$i) {}
	  my $first_region=$i;
	  for (++$i; (incl($regions->[$i],$edge)!=1)&&($i<$n_regions); ++$i) {}
	  my $second_region=$i;
	  # take the MONOMIALS corresponding to the two REGIONS
	  my ($i1,$i2)=($irredundant->[$first_region],$irredundant->[$second_region]);
	  my ($m1,$m2)=($points->[$i1],$points->[$i2]);
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
     #print @moduli_ray;
      $moduli_matrix1->row($r)=new Vector(@moduli_ray);
  } # end ray
 
 #removing zero vectors since INPUT_RAYS need to be non_negative
  for(my $k=0; $k<$n_rays; ++$k) {
  if($moduli_matrix1->row($k) != $z){
  $f = $f + 1;
  }
  }
  my $moduli_matrix=new Matrix($f,$n_skeleton_edges);
   my $y = 0;
  for(my $x=0; $x<$n_rays; ++$x) {
  if($moduli_matrix1->row($x) != $z){
  $moduli_matrix->row($y) = $moduli_matrix1->row($x);
  $y = $y + 1;
  }
  }
  
  # pointed since all coordinates are non_negative; helps to avoid a small bug
  my $moduli_cone=new Cone(INPUT_RAYS=>$moduli_matrix,POINTED=>1);
  my $mc_name=$c->name."-moduli";
  $moduli_cone->name=$mc_name;
  $moduli_cone->attach("ID",$id);
  $moduli_cone->attach("BUCKET",$b);
  $moduli_cone->attach("POLYTOPE",$polytope);
  $moduli_cone->attach("GENUS",$genus);
  my $schedule=$moduli_cone->get_schedule("CONE_DIM","RAYS","FACETS");
  $schedule->apply($moduli_cone);  # force computation of dimension etc
  save $moduli_cone, "g$genus"."b$mc_name";
} # end cone

# main function, 
sub moduli(@) {
      my $c=load("g$genus.cone");
      moduli_one_cone($c);
    print STDERR "\n";
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
