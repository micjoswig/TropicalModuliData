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
    if ($#{${$de_incident}[$v]}==1) {# node v has degree 2
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
    my $intersection=$triangle1*$triangle2;
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

	my $Sigma=$c->get_attachment("INDUCED_TRIANGULATION");
	my $de_array=$c->get_attachment("DUAL_EDGE_ARRAY");#The dual graph edges as array of sets
	my $n_dual_edges=$de_array->size();

    # for each node (=triangle) incident dual edges
	my @de_incident=(); # array of arrays: e.g. @{$de_incident[1]} contains the edges incident to the vertex with label 1.
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

    # maps each dual edge to one edge of the skeleton (or to -1 which means that this edge is deleted)
	my $de_map=new Array<Int>(map {-2} 0..$n_dual_edges-1); #init: all -2 entries, length: n_dual_edges

    
    # delete edges of degree 1
	while (@queue) {
		my $t=shift(@queue);
		my $e=$de_incident[$t]->[0]; # unique incident edge
        my $u=get_other_node($de_array->[$e],$t);
        $de_incident[$t]=[]; # delete node t
		# delete edge e from adjacency list of node u
	    #print_dual_graph_inc(\@de_incident, "vor");	
        my $k=0; for (; $de_incident[$u]->[$k]!=$e; ++$k) {}; # get first(end only) index of incdence list of u that refers to edge e.
        splice @{$de_incident[$u]},$k,1; #delete k-th element of incidence list of node u
	    #print_dual_graph_inc(\@de_incident, "nach");	
		if ($#{$de_incident[$u]}==0) { push @queue, $u; } # check if u's degree dropped to 1
		$de_map->[$e]=-1;# delete edge e
	}
   
    #Now, according to the nodes of degree 1 the de_incident list was manipulated and contains only nodes of degree higher than 1.
    
    #print_dual_graph_inc(\@de_incident, "after deg 1 manipul"); 

    
    # collect all nodes of degree 2
	@queue=();
	for (my $t=0; $t<=$#de_incident; ++$t) {
		if ($#{$de_incident[$t]}==1) { push @queue, $t; }
	}

    # contract edges (rather 'glue edges')
    # note 1: that in de_map the entries are -2 (untouched) or deleted (-1) within the degree 1 process.
    # note 2: only $de_map is changed here. Whenever edges are glued (due to the degree 2 constraint), the entry in the de_map array is set to the value $skeleton_edge.
	my $skeleton_edge=0;
	while (@queue) {
		my $t=shift(@queue);
		my ($e,$f)=($de_incident[$t]->[0],$de_incident[$t]->[1]);# e and f are the two unique edges adjacent to t.
		if ($de_map->[$e]<0) { # edge (and entire path) unmarked; value must be equal to -2 (untouched).
			# relabel
            mark_path($de_array,$de_map,\@de_incident,$e,$t,$skeleton_edge);
			mark_path($de_array,$de_map,\@de_incident,$f,$t,$skeleton_edge);
			++$skeleton_edge;
		}
	}
	
    # clean up: de_map, edges with value -2 get their own $skeleton_edge value now. Every entry of de_map will be bigger than -2 afterwards.
	for (my $e=0; $e<$n_dual_edges; ++$e) {
		if ($de_map->[$e]==-2) { # still not touched, so edge is by itself
			$de_map->[$e]=$skeleton_edge++;
		}
	}

	my $de_reps=new Set();# contains labels of the skeleton edges. 
	map { $de_reps += $de_map->[$_] } (0..$n_dual_edges-1);
    
    $de_reps-=-1; # does not represent any edge

	# make sure that the same skeleton edge gets the same number for different triangulations
		my $this_skeleton=skeleton_inc(\@de_incident,$de_array,$de_map,$Sigma);
	if ($skeleton_of_reference->rows()) {
		# the rows of the IncidenceMatrix describing a graph come in two kinds: first the nodes, then the regions (of the planar embedding)
		my $n_nodes=2*($genus-1);
		# restrict everything to the nodes, i.e., ignore the planar embedding
		my $restricted_skeleton_of_reference=$skeleton_of_reference->minor(sequence(0,$n_nodes),All);
		my $this_restricted_skeleton=$this_skeleton->minor(sequence(0,$n_nodes),All);
		# the following raises an exception if the skeleta are not isomorphic as abstract graphs
		my $row_col_perm=find_row_col_permutation($restricted_skeleton_of_reference,$this_restricted_skeleton);
		my $edge_perm=$row_col_perm->second; # permutation of the columns
		my $permuted_de_map=new Array<Int>(map { $_<0 ? $_ : $edge_perm->[$_] } @$de_map);
		$de_map=$permuted_de_map;
	} 
		else {
		print STDERR " [sets skeleton]";
		save_data($this_skeleton,$skeleton_file,"skeleton g=$genus polytope=$polytope bucket=$b");
		$skeleton_of_reference=$this_skeleton;
		die "geht in komische else Schleife und speichert. \n"
	}
	
	$c->attach("DUAL_EDGE_SKELETON_MAP",$de_map);
	$c->attach("N_SKELETON_EDGES",$de_reps->size());
	
	save $c;

	return $skeleton_of_reference;
}

sub skeleton(@) {
	print STDERR "skeleton g=$genus polytope=$polytope\n";
	foreach my $b (@_) {
		my $bprefix=$prefix."b$b";
		my $skeleton_file="$wd_path/$bprefix/$bprefix-skeleton.dat";
		print STDERR "bucket $b, skeleton=$skeleton_file\n";
		my $skeleton_of_reference = new IncidenceMatrix();
		eval { $skeleton_of_reference=load_data($skeleton_file) };
        if ($@) { print STDERR " not found"; }
		#print "skeleton of reference: \n", $skeleton_of_reference->VISUAL, "\n\n";
		print STDERR ", triangulations:";
		for my $id (@{load_data("$wd_path/$bprefix/$bprefix-ids.dat")}) {
				my $c=load("$wd_path/$bprefix/$bprefix-$id.cone");
				$skeleton_of_reference=skeleton_one_cone($c,$skeleton_of_reference,$skeleton_file);#don't know wat the assignment is good for. Skeleton is not manipulated.
		}
		print STDERR "\n";
	}
}

sub print_dual_graph_inc{
my @de_incident = @{$_[0]};
my $mode = $_[1];
my $vert = 0;
for my $item (@de_incident){
        ++$vert;    
    }
}


# Local Variables:
# mode: cperl
# c-basic-offset:2
# End:
