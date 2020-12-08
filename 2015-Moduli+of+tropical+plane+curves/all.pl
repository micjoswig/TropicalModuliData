# Brodsky, Joswig, Morrison & Sturmfels: Moduli of Plane Tropical Curves
# various tools geared towards combining the moduli space from several polytopes

# prior to using do 'script "gXX/setupYY.pl";' to define the geometric data
# ... and secondary_cones, standard_secondary_cones, skeleton, moduli

use application "polytope";

declare $polygons=load_data("$wd_path/g$genus-polygons.dat");

# skeleton-type -> skeleton-subtype -> bucket-dir

#my $Map_file="$wd_path/g$genus-map.dat";

foreach my $p (@$polygons) {
  my $all_buckets_file="$wd_path/g$genus$p-buckets.dat";
  if (-e $all_buckets_file) {
    my $all_buckets=load_data($all_buckets_file);
    print STDERR "$p: $all_buckets\n";
    foreach my $b (@$all_buckets) {
      my $skeleton_file="$wd_path/g$genus$p"."b$b/g$genus$p"."b$b-skeleton.dat";
      my $skeleton=load_data($skeleton_file);
      my $skeleton_type=skeleton_type($skeleton);
      print STDERR " b=$b:[$skeleton_type]";
      if (exists($Map{$skeleton_type})) {
	my $n_keys=keys(%{$Map{$skeleton_type}});
	print STDERR ",exists($n_keys)";
	my $key;
	foreach $key (sort(keys(%{$Map{$skeleton_type}}))) {
	  my $other_skeleton=load_data("$wd_path/$key/$key-skeleton.dat");
	  if (isomorphic($skeleton,$other_skeleton)) {
	    print STDERR ",isomorphic";
	  } else {
	    print STDERR ",not_isomorphic";
	  }
	}
      } else {
	my $new_key="a";
	my $new_value="g$genus$p"."b$b";
	my %new_entry=([$new_key,$new_value]);
	$Map{$skeleton_type}=\%new_entry;
      }
    }
    print STDERR "\n";
  } else {
    print STDERR "$all_buckets_file not found\n";
  }
}



# Local Variables:
# mode: cperl
# c-basic-offset:2
# End:
