# Brodsky, Joswig, Morrison & Sturmfels: Moduli of Plane Tropical Curves
# compute skeleta; to be called from "Computations".

# prior to using do 'script "gXX/setupYY.pl";' to define the geometric data
# ... and secondary_cones, standard_secondary_cones

use application "polytope";

# prior to using do something like 'script "setup.pl";'
# to define the geometric data
# assumes that results from standard_secondary_cones.pl are available

# A skeleton is multigraph with trivalent nodes, embedded into the plane.
# It is encoded as an incidence matrix of nodes/regions versus edges.  The rows begin with the nodes,
# followed by the regions.  The columns correspond to the edges.

# given an edge and one of its nodes, return the other node
sub get_other_node($$) {
  my ($edge,$node)=@_; # Set (with two elements), Int
  my ($a,$b)=($edge->[0],$edge->[-1]);
  return ($node==$a ? $b : $a);
}

# take an edge and extend it to a path as long as the endpoints are nodes of degree 2
sub mark_path($$$$$$) {
  my ($de_array,$de_map,$de_incident,$e,$u,$skeleton_edge)=@_;
  for (;;) {
    my $v=get_other_node($de_array->[$e],$u);
    $de_map->[$e]=$skeleton_edge;
    if ($#{${$de_incident}[$v]}==1) {
      if (${$de_incident}[$v]->[0]==$e) {
	$e=${$de_incident}[$v]->[1];
      } else {
	$e=${$de_incident}[$v]->[0];
      }
      $u=$v;
    } else {
      last;
    }
  }
}

# Return the node-edge incidence matrix of the skeleton
# provided that all nodes have degree two or three
# (that is, the nodes of degree one have already been sorted out).
# The resulting incidence matrix has two kinds of nodes; first the ones which are the
# actual nodes; second nodes corresponding to the regions.
sub skeleton_inc($$$$) {
  my ($de_incident_ref,$de_array,$de_map,$Sigma)=@_;
  my @skeleton;
  # nodes corresponding to nodes in the skeleton as an abstract graph
  for (my $t=0; $t<=$#{$de_incident_ref}; ++$t) {
    if ($#{$de_incident_ref->[$t]}==2) {
      my @incident_edges = map { $de_map->[$_] } @{$de_incident_ref->[$t]};
      push @skeleton, \@incident_edges;
    }
  }
  # nodes corresponding to regions with respect to planar embedding
  my $n_nodes=scalar(@skeleton);
  my $n_dual_edges=$de_array->size();
  for (my $e=0; $e<$n_dual_edges; ++$e) {
    my $skeleton_edge=$de_map->[$e];
    next if $skeleton_edge<0; # does not occur in the skeleton
    my ($idx1,$idx2) = ($de_array->[$e]->[0],$de_array->[$e]->[-1]);
    my ($triangle1,$triangle2)=($Sigma->[$idx1],$Sigma->[$idx2]);
    #print $triangle1;
    #print $triangle2;
    my $intersection= $triangle1 * $triangle2;
    #print $intersection;
    my ($vertex1,$vertex2) = ($intersection->[0], $intersection->[-1]);
    my $ilp_idx1=$ilp_hash{$vertex1};
    push @{$skeleton[$n_nodes+$ilp_idx1]}, $skeleton_edge if defined($ilp_idx1);
    my $ilp_idx2=$ilp_hash{$vertex2};
    push @{$skeleton[$n_nodes+$ilp_idx2]}, $skeleton_edge if defined($ilp_idx2);
    #	print STDERR " [e=$e se=$skeleton_edge v1=$vertex1 v2=$vertex2 ilp1=$ilp_idx1 ilp2=$ilp_idx2]";
  }
  return new IncidenceMatrix(\@skeleton);
}

sub skeleton_one_cone($$$) {
  my ($c,$skeleton_of_reference,$skeleton_file)=@_;
  my $id=$c->get_attachment("ID");
  my $b=$c->get_attachment("BUCKET");
  print STDERR " $id";

  my $Sigma=$c->get_attachment("TRIANGULAT");
  my $de_array=$c->get_attachment("DUAL_EDGE_ARRAY");
  my $n_dual_edges=$de_array->size();

# for each node (=triangle) incident dual edges
  my @de_incident=(); # array of arrays
  my $i=0;
  foreach my $edge (@{$de_array}) {
      my ($lo,$hi)=@{$edge}; # here always: $lo < $hi
      push @{$de_incident[$lo]}, $i;
      push @{$de_incident[$hi]}, $i;
      ++$i;
  }

  my @queue=();
# collect all nodes of degree 1
  for (my $t=0; $t<=$#de_incident; ++$t) {
    if ($#{$de_incident[$t]}==0) { push @queue, $t; }
  }

# maps each dual edge to one edge of the skeleton (or to -1 if edge deleted)
  my $de_map=new Array<Int>(map {-2} 0..$n_dual_edges-1);

# delete edges
  while (@queue) {
    my $t=shift(@queue);
    my $e=$de_incident[$t]->[0]; # unique incident edge
    my $u=get_other_node($de_array->[$e],$t);
    $de_incident[$t]=[]; # delete node t
    # delete edge e from adjacency list of node u
    my $k=0; for (; $de_incident[$u]->[$k]!=$e; ++$k) {};
    splice @{$de_incident[$u]},$k,1;
    if ($#{$de_incident[$u]}==0) { push @queue, $u; } # check if u's degree dropped to 1
    $de_map->[$e]=-1;
  }

# collect all nodes of degree 2
  @queue=();
  for (my $t=0; $t<=$#de_incident; ++$t) {
    if ($#{$de_incident[$t]}==1) { push @queue, $t; }
  }

# contract edges
  my $skeleton_edge=0;
  while (@queue) {
    my $t=shift(@queue);
    my ($e,$f)=($de_incident[$t]->[0],$de_incident[$t]->[1]);
    if ($de_map->[$e]<0) { # edge (and entire path) unmarked; value must be equal to -2
      # relabel
      mark_path($de_array,$de_map,\@de_incident,$e,$t,$skeleton_edge);
      mark_path($de_array,$de_map,\@de_incident,$f,$t,$skeleton_edge);
      ++$skeleton_edge;
    }
  }
  
# clean up
  for (my $e=0; $e<$n_dual_edges; ++$e) {
    if ($de_map->[$e]==-2) { # still not touched, so edge is by itself
      $de_map->[$e]=$skeleton_edge++;
    }
  }
  
  my $de_reps=new Set();
  map { $de_reps += $de_map->[$_] } (0..$n_dual_edges-1);
  $de_reps-=-1; # does not represent any edge

  # make sure that the same skeleton edge gets the same number for different triangulations
  my $this_skeleton=skeleton_inc(\@de_incident,$de_array,$de_map,$Sigma);

    print STDERR " [sets skeleton]";
    save_data($this_skeleton,$skeleton_file,"skeleton g=$genus polytope=$polytope bucket=$b");
    $skeleton_of_reference=$this_skeleton;
  
  $c->attach("DUAL_EDGE_SKELETON_MAP",$de_map);
  $c->attach("N_SKELETON_EDGES",$de_reps->size());
  
  save $c;

  return $skeleton_of_reference;
}

sub skeleton(@) {
  print STDERR "skeleton g=$genus polytope=$polytope\n";
   print STDERR "\n";
      my $skeleton_file="g$genus-1-skeleton.dat";
      my $skeleton_of_reference = new IncidenceMatrix();
      my $c=load("g$genus.cone");
      $skeleton_of_reference=skeleton_one_cone($c,$skeleton_of_reference,$skeleton_file);
    print STDERR "\n";
}

# Local Variables:
# mode: cperl
# c-basic-offset:2
# End:
