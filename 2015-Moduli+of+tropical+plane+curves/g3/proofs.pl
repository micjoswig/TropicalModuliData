# Brodsky, Joswig, Morrison & Sturmfels: Moduli of Plane Tropical Curves
# g3 computational proofs

use application "polytope";

# prior to using do something like 'script "*/setup.pl";' to define the geometric data
# assumes that results from the following scripts are available:
# standard_secondary_cones.pl, skeleton.pl, moduli.pl

script "g3/setup.pl";

# Theorem 5.1: checking the honeycomb inequalities, bucket #7
# Graph 1 is realizable if and only if max{x, y} ≤ u, max{x, z} ≤ v, and max{y, z} < w,
# where u = v in the case where both max{x, y} = u and max{x, z} = v.
# graph symmetry generated by (uvw)(xzy)
# VERIFIED: 14-07-08
sub check_honeycomb($) {
  my ($m)=@_;
  my $id=$m->get_attachment("ID");
  my $b=$m->get_attachment("BUCKET");
  die "triangulation $id found in bucket $b, expected bucket 7" unless $b==7;
  my $error=0;
  # weak inequalities
  my $moduli_rays=$m->RAYS;
  for (my $i=0; $i<$moduli_rays->rows(); ++$i) {
    my ($u,$v,$w,$x,$y,$z) = map { $moduli_rays->[$i]->[$_] } 0..5;
    if (max($x,$y)>$u) { print STDERR "$id [RAY $i u FAILED: x=$x y=$y u=$u]\n";  $error=1; }
    if (max($x,$z)>$v) { print STDERR "$id [RAY $i v FAILED: x=$x y=$z v=$v]\n";  $error=1; }
    if (max($y,$z)>$w) { print STDERR "$id [RAY $i w FAILED: y=$y z=$z w=$w]\n";  $error=1; }
  }
  # strict inequalities
  my ($u,$v,$w,$x,$y,$z)=@{primitive($m->REL_INT_POINT)};
  if (max($y,$z)>=$w && max($x,$y)>=$u && max($x,$z)>=$v) {
    print STDERR "$id [strict FAILED u=$u v=$v w=$w x=$x y=$y z=$z CONE_DIM=", $m->CONE_DIM, "]\n";
    $error=1;
  } else {
    if ($x>$y && $y>$z && $u==$v && $v==$x) { # ()
      print STDERR "$id [x>y>z FAILED u=$u v=$v w=$w x=$x y=$y z=$z CONE_DIM=", $m->CONE_DIM, "]\n";
      $error=1;
    } elsif ($x>$z && $z>$y && $v==$u && $u==$x) { # (yz)(uv)
      print STDERR "$id [x>z>y FAILED u=$u v=$v w=$w x=$x y=$y z=$z CONE_DIM=", $m->CONE_DIM, "]\n";
      $error=1;
    } elsif ($y>$z && $z>$x && $w==$u && $u==$y) { # (xyz)(uwv)
      print STDERR "$id [y>z>x FAILED u=$u v=$v w=$w x=$x y=$y z=$z CONE_DIM=", $m->CONE_DIM, "]\n";
      $error=1;
    } elsif ($y>$x && $x>$z && $u==$w && $w==$y) { # (xy)(vw))
      print STDERR "$id [y>x>z FAILED u=$u v=$v w=$w x=$x y=$y z=$z CONE_DIM=", $m->CONE_DIM, "]\n";
      $error=1;
    } elsif ($z>$x && $x>$y && $v==$w && $w==$z) { # (xzy)(uvw)
      print STDERR "$id [z>x>y FAILED u=$u v=$v w=$w x=$x y=$y z=$z CONE_DIM=", $m->CONE_DIM, "]\n";
      $error=1;
    } elsif ($z>$y && $y>$x && $w==$v && $v==$z) { # (xz)(uw)
      print STDERR "$id [z>y>x FAILED u=$u v=$v w=$w x=$x y=$y z=$z CONE_DIM=", $m->CONE_DIM, "]\n";
      $error=1;
    }
  }
  return $error;
}

# Theorem 5.1: checking the mickey_mouse inequalities, bucket #3
# Graph 2 is realizable if and only if v ≤ u, y ≤ z, and w + max{v, y} ≤ x, where
# w + max{v, y} = x and v = u implies v < y < z, and where w + max{v, y} = x and
# y = z implies y < v < u.
# symmetry generated by (uz)(vy) and (wx)
# VERIFIED: 14-07-08
sub check_mickey_mouse($) {
  my ($m)=@_;
  my $id=$m->get_attachment("ID");
  my $b=$m->get_attachment("BUCKET");
  die "triangulation $id found in bucket $b, expected bucket 3" unless $b==3;
  print STDERR " $id";
  my $error=0;
  # weak inequalities
  my $moduli_rays=$m->RAYS;
  for (my $i=0; $i<$moduli_rays->rows(); ++$i) {
    my ($u,$v,$w,$x,$y,$z) = map { $moduli_rays->[$i]->[$_] } 0..5;
    if ($v>$u) { print STDERR " [RAY $i uv FAILED u=$u v=$v]";  $error=1; }
    if ($y>$z) { print STDERR " [RAY $i zy FAILED y=$y z=$z]";  $error=1; }
    if ($w+max($v,$y)>$x && $x+max($v,$y)>$w) { print STDERR " [RAY $i x-w FAILED v=$v w=$w x=$x y=$y]";  $error=1; }
  }
  # strict inequalities
  my ($u,$v,$w,$x,$y,$z)=@{primitive($m->REL_INT_POINT)};
  if ($w+max($v,$y)==$x || $x+max($v,$y)==$w) {
    if ($v==$u && ($v>=$y || $y>=$z)) {
      print STDERR " [strict wx-vu FAILED u=$u v=$v w=$w x=$x y=$y z=$z]";  $error=1;
    }
    if ($y==$z && ($y>=$v || $v>=$u)) {
      print STDERR " [strict wx-yz FAILED u=$u v=$v w=$w x=$x y=$y z=$z]";  $error=1;
    }
  }
  return $error;
}

# Theorem 5.1: checking the one_bridge inequalities, bucket #0
# Graph 3 is realizable if and only if w < x and one of the following conditions holds:
#  v + w = x and v < u, or
#  v + w < x ≤ v + 3w and v ≤ u, or
#  v + 3w < x ≤ v + 4w and v ≤ u ≤ 3v/2, or
#  v + 4w < x ≤ v + 5w and v=u.
#  w+v<x≤4w+v, u=2v (New inequality added 12 Sept. 2014)
# symmetry generated by (wx)
# PREVIOUS VERSION VERIFIED: 14-07-09 (but not tight enough)
# VERSION VERIFIED ON 12 SEPT. 2014
sub check_one_bridge($) {
  my ($m)=@_;
  my $id=$m->get_attachment("ID");
  my $b=$m->get_attachment("BUCKET");
  die "triangulation $id found in bucket $b, expected bucket 0" unless $b==0;
  # check strict inequalities at interior point to determine the type
  my ($u,$v,$w,$x,$y,$z)=@{primitive($m->REL_INT_POINT)};
  my $type=0;
  if ($w<$x) {
    if ($v+$w==$x && $v<$u) { $type=1; }
    elsif ($v+$w<$x && $x<=$v+3*$w && $v<=$u) { $type=2; }
    elsif ($v+3*$w<$x && $x<=$v+4*$w && $v<=$u && $u<=3/2*$v) { $type=3; }
    elsif ($v+4*$w<$x && $x<=$v+5*$w && $v==$u) { $type=4; }
    elsif ($w+$v<$x &&  $x<=4*$w+$v && $u==2*$v) { $type=5; }
    else {
      print STDERR "$id [w<x strict FAILED u=$u v=$v w=$w x=$x y=$y z=$z]\n";
      return 1; # error
    }
  } elsif ($x<$w) {
    if ($v+$x==$w && $v<$u) { $type=-1; }
    elsif ($v+$x<$w && $w<=$v+3*$x && $v<=$u) { $type=-2; }
    elsif ($v+3*$x<$w && $w<=$v+4*$x && $v<=$u && $u<=3/2*$v) { $type=-3; }
    elsif ($v+4*$x<$w && $w<=$v+5*$x && $v==$u) { $type=-4; }
    elsif ($x+$v<$w && $w<=4*$x+$v && $u==2*$v) { $type=-5; }
    else {
      print STDERR "$id [x<w strict FAILED u=$u v=$v w=$w x=$x y=$y z=$z]\n";
      return 1; # error
    }
  } else {
      print STDERR "$id [x=w! strict FAILED u=$u v=$v w=$w x=$x y=$y z=$z]\n";
      return 1; # error
  }
  my $error=0;
  my $moduli_rays=$m->RAYS;
  for (my $i=0; $i<$moduli_rays->rows(); ++$i) {
    my ($u,$v,$w,$x,$y,$z) = map { $moduli_rays->[$i]->[$_] } 0..5;
    next if $type>0 && $v+$w==$x && $v<=$u;
    next if $type>0 && $v+$w<=$x && $x<=$v+3*$w && $v<=$u;
    next if $type>0 && $v+3*$w<=$x && $x<=$v+4*$w && $v<=$u && $u<=3/2*$v;
    next if $type>0 && $v+4*$w<=$x && $x<=$v+5*$w && $v==$u;
    next if $type>0 && $w+$v<=$x && $x<=4*$w+$v && $u==2*$v;
    # exchange the role of x and w
    next if $type<0 && $v+$x==$w && $v<=$u;
    next if $type<0 && $v+$x<=$w && $w<=$v+3*$x && $v<=$u;
    next if $type<0 && $v+3*$x<=$w && $w<=$v+4*$x && $v<=$u && $u<=3/2*$v;
    next if $type<0 && $v+4*$x<=$w && $w<=$v+5*$x && $v==$u;
    next if $type<0 && $x+$v<=$w && $w<=4*$x+$v && $u==2*$v;
    print STDERR "$id [type=$type RAY $i FAILED u=$u v=$v w=$w x=$x y=$y z=$z]\n";
    $error=1;
  }
  return $error;
}

# Theorem 5.1: checking the two_bridge inequalities, bucket #31
# Graph 4 is realizable if and only if w < x ≤ 2w.
# symmetry generated by (wx) and (uz)(vy)
# VERIFIED: 14-07-08
sub check_two_bridge($) {
  my ($m)=@_;
  my $id=$m->get_attachment("ID");
  my $b=$m->get_attachment("BUCKET");
  die "triangulation $id found in bucket $b, expected bucket 31" unless $b==31;
  print STDERR " $id";
  my $error=0;
  my $type;
  # check strict inequalities at interior point to determine the type
  my ($u,$v,$w,$x,$y,$z)=@{primitive($m->REL_INT_POINT)};
  if ($w<$x) {
    $type=1;
  } elsif ($x<$w) {
    $type=2;
  } else {
    print STDERR " [strict FAILED u=$v v=$v w=$w x=$x y=$y z=$z]";  $error=1;
  }
  # weak inequalities
  if ($error==0) { # does not make any sense to check without knowledge of w versus x
    my $moduli_rays=$m->RAYS;
    for (my $i=0; $i<$moduli_rays->rows(); ++$i) {
      my ($u,$v,$w,$x,$y,$z) = map { $moduli_rays->[$i]->[$_] } 0..5;
      if ($type==1 && ($w>$x || $x>2*$w)) { print STDERR " [type w<x RAY $i FAILED w=$w x=$x]";  $error=1; }
      if ($type==2 && ($x>$w || $w>2*$x)) { print STDERR " [type x<w RAY $i FAILED w=$w x=$x]";  $error=1; }
    }
  }
  return $error;
}

sub check_bucket($) {
  my ($b)=@_;
  my $unverified_cones=0;
  my $bprefix=$prefix."b$b";
  my $ids=load_data("$wd_path/$bprefix/$bprefix-ids.dat");
  print "bucket $b of size ", $ids->size(), ":";
  my $i=0;
  if ($b==0) {
    foreach my $m (map { load("$wd_path/$bprefix/moduli/$bprefix-$_-moduli.cone") } @$ids) {
      $unverified_cones += check_one_bridge($m); ++$i;
    }
  } elsif ($b==3) {
    foreach my $m (map { load("$wd_path/$bprefix/moduli/$bprefix-$_-moduli.cone") } @$ids) {
      $unverified_cones += check_mickey_mouse($m); ++$i;
    }
  } elsif ($b==7) {
    foreach my $m (map { load("$wd_path/$bprefix/moduli/$bprefix-$_-moduli.cone") } @$ids) {
      $unverified_cones += check_honeycomb($m); ++$i;
    }
  } elsif ($b==31) {
    foreach my $m (map { load("$wd_path/$bprefix/moduli/$bprefix-$_-moduli.cone") } @$ids) {
      $unverified_cones += check_two_bridge($m); ++$i;
    }
  } else {
    die " not found";
  }
  print "\nunverified cones=", $unverified_cones, " out of $i checked\n";
}

# Local Variables:
# mode: cperl
# c-basic-offset:2
# End:
