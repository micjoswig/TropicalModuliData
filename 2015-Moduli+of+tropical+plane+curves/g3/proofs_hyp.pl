# Brodsky, Joswig, Morrison & Sturmfels: Moduli of Plane Tropical Curves
# g3 computational proofs, hyperelliptic case

use application "polytope";

# prior to using do something like 'script "*/setup.pl";' to define the geometric data
# assumes that results from the following scripts are available:
# standard_secondary_cones.pl, skeleton.pl, moduli.pl

#script "g3/setup_hyp.pl";

# (212)/two bridge/#0:  you get all hyperelliptic graphs (nothing to check here).
# 
# (111)/one bridge/#1:  you get all hyperelliptic graphs of this combinatorial type (i.e.
# those with w=x) EXCEPT for those with both u and v strictly greater than w.
# 

# (020)/mickey_mouse/#10:  At least one of the following conditions must hold:
# A (020) graph is achievable is is achievable if and only if w=x, min{u,v}≤min{y,z}, and:
# (i)   (min{y,z}<min{u,v}+2w) or
# (ii)  (min{y,z}=min{u,v}+2w and y≠z) or
# (iii) (min{y,z}<min{u,v}+3w and max{u,v}≤2min{u,v} or
# (iv)  (min{y,z}=min{u,v}+3w and max{u,v}≤2min{u,v} and y≠z) or
# (v)   (min{y,z}<min{u,v}+4w and u=v) or
# (vi)  (min{y,z}=min{u,v}+4w and u=v and y≠z).
# symmetry generated by (uv), (yz), (wx), (uy)(vz)
# gap> M:=Group( (u,v), (y,z), (u,y)(v,z) );
# gap> Elements(M);
# [ (), (y,z), (u,v), (u,v)(y,z), (u,y)(v,z), (u,y,v,z), (u,z,v,y), (u,z)(v,y) ]
# FINAL VERSION checked: 140915
sub check_mickey_mouse($) {
  my ($m)=@_;
  my $id=$m->get_attachment("ID");
  my $b=$m->get_attachment("BUCKET");
  if (($polytope eq "hyp" && $b!=10) || ($polytope eq "hyptri" && $b!=0)) {
    die "triangulation $id found in bucket $b, not a mickey mouse";
  }
  my $strict_error=0; my $weak_error=0;
  # strict inequalities for relative interior point; determine the type (i) though (iv)
  my ($u,$v,$w,$x,$y,$z)=@{primitive($m->REL_INT_POINT)};
  if ($w!=$x) { print STDERR " [id=$id: relint strict x=w FAILED u=$u v=$v w=$w x=$x y=$y z=$z]";  $strict_error=1; }
  my $min_uv=min($u,$v); my $min_yz=min($y,$z);
  if ($min_uv<=$min_yz) {
    if (   ($min_yz<$min_uv+2*$w) # (i)
	|| ($min_yz==$min_uv+2*$w && $y!=$z) # (ii)
	|| ($min_yz<$min_uv+3*$w && max($u,$v)<=2*$min_uv) # (iii)
	|| ($min_yz==$min_uv+3*$w && max($u,$v)<=2*$min_uv && $y!=$z) # (iv)
	|| ($min_yz<$min_uv+4*$w && $u==$v) # (v)
	|| ($min_yz==$min_uv+4*$w && $u==$v && $y!=$z)) { # (vi)
      # OK, nothing to do
    } else { print STDERR " [id=$id: relint min(u,v)<=min(y,z) strict (uvyz) FAILED u=$u v=$v w=$w x=$x y=$y z=$z]";  $strict_error=1; }
  } else { # min(y,z)>min(u,v), swap uv <-> yz
    if (   ($min_uv<$min_yz+2*$w) # (i)
	|| ($min_uv==$min_yz+2*$w && $u!=$v) # (ii)
	|| ($min_uv<$min_yz+3*$w && max($y,$z)<=2*$min_yz) # (iii)
	|| ($min_uv==$min_yz+3*$w && max($y,$z)<=2*$min_yz && $u!=$v) # (iv)
	|| ($min_uv<$min_yz+4*$w && $y==$z) # (v)
	|| ($min_uv==$min_yz+4*$w && $y==$z && $u!=$v)) { # (vi)
      # OK, nothing to do
    } else { print STDERR " [id=$id: relint min(u,v)>min(y,z) strict (uvyz) FAILED u=$u v=$v w=$w x=$x y=$y z=$z]";  $strict_error=1; }
  }
  # weak inequalities
  my $moduli_rays=$m->RAYS;
  for (my $i=0; $i<$moduli_rays->rows(); ++$i) {
    my ($u,$v,$w,$x,$y,$z) = map { $moduli_rays->[$i]->[$_] } 0..5;
    if ($w!=$x) { print STDERR " [id=$id ray=$i x=w FAILED u=$u v=$v w=$w x=$x y=$y z=$z]";  $weak_error=1; }
    my $min_uv=min($u,$v); my $min_yz=min($y,$z);
    if ($min_uv<=$min_yz) {
      if (   ($min_yz<=$min_uv+2*$w) # (i) + (ii)
	  || ($min_yz<=$min_uv+3*$w && max($u,$v)<=2*$min_uv) # (iii)
	  || ($min_yz==$min_uv+3*$w && max($u,$v)<=2*$min_uv) # (iv)
	  || ($min_yz<=$min_uv+4*$w && $u==$v) # (v)
	  || ($min_yz==$min_uv+4*$w && $u==$v)) { # (vi)
	# OK, nothing to do
      } else { print STDERR " [id=$id ray=$i min(u,v)<=min(y,z) weak (uvyz) FAILED u=$u v=$v w=$w x=$x y=$y z=$z]";  $weak_error=1; }
    } else { # min(y,z)>min(u,v), swap uv <-> yz
      if (   ($min_uv<=$min_yz+2*$w) # (i) + (ii)
	  || ($min_uv<=$min_yz+3*$w && max($y,$z)<=2*$min_yz) # (iii)
	  || ($min_uv==$min_yz+3*$w && max($y,$z)<=2*$min_yz) # (iv)
	  || ($min_uv<=$min_yz+4*$w && $y==$z) # (v)
	  || ($min_uv==$min_yz+4*$w && $y==$z)) { # (vi)
	# OK, nothing to do
      } else { print STDERR " [id=$id ray=$i min(u,v)>min(y,z) weak (uvyz) FAILED u=$u v=$v w=$w x=$x y=$y z=$z]";  $weak_error=1; }
    }
  }
  return [$strict_error,$weak_error];
}

sub check_bucket($) {
  my ($b)=@_;
  my $unverified_cones=0;
  my $bprefix=$prefix."b$b";
  my $ids=load_data("$wd_path/$bprefix/$bprefix-ids.dat");
  my $i=0;
  my ($ts,$tw);
  print STDERR "polytope=$polytope bucket $b of size ", $ids->size(), ":";
  if (($polytope eq "hyp" && $b==10) || ($polytope eq "hyptri" && $b==0)) {
    foreach my $m (map { load("$wd_path/$bprefix/moduli/$bprefix-$_-moduli.cone") } @$ids) {
      my ($strict,$weak)=@{check_mickey_mouse($m)};
      $ts+=$strict; $tw+=$weak;
      ++$unverified_cones if ($strict>0 || $weak>0);
      ++$i;
    }
  } else {
    print STDERR " omitted";
  }
  print STDERR "\nunverified cones=", $unverified_cones, " out of $i checked [strict=$ts weak=$tw]\n";
}

# Local Variables:
# mode: cperl
# c-basic-offset:2
# End: