use application "polytope";

sub move(@) {
  for my $b (@_) {
    my $old_bprefix="g5Ab$b";
    my $new_bprefix=$prefix."b$b";
    my $old_bucket_ids_file="$wd_path/$old_bprefix/$old_bprefix-ids.dat";
    my $new_bucket_ids_file="$wd_path/$old_bprefix/$new_bprefix-ids.dat";
    my $old_bucket_skeleton_file="$wd_path/$old_bprefix/$old_bprefix-skeleton.dat";
    my $new_bucket_skeleton_file="$wd_path/$old_bprefix/$new_bprefix-skeleton.dat";
    my $bucket_ids;
    eval { $bucket_ids=load_data($old_bucket_ids_file) };
    die "$old_bucket_ids_file not found" if $@;
    system "git mv $old_bucket_ids_file $new_bucket_ids_file";
    my $bucket_size=$bucket_ids->size();
    my $btotal=0;
    my @bucket_dimensions=();
    print "$b=[", skeleton_type(load_data($old_bucket_skeleton_file)), "] ";
    system "git mv $old_bucket_skeleton_file $new_bucket_skeleton_file";
    for my $id (@$bucket_ids) {
      system "git mv $wd_path/$old_bprefix/$old_bprefix-$id.cone $wd_path/$old_bprefix/$new_bprefix-$id.cone";
      system "git mv $wd_path/$old_bprefix/moduli/$old_bprefix-$id-moduli.cone $wd_path/$old_bprefix/moduli/$new_bprefix-$id-moduli.cone";
    }
  }
}

# Local Variables:
# mode: cperl
# c-basic-offset:2
# End:
