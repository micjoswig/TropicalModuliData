# call setup.pl before using this

# iterate over all the cones in one directory
foreach my $c (map { load($_) } glob("*.cone")) {
  my $id=$c->get_attachment("ID");
  print STDERR "$id:";
  for (my $i=0; $i<$c->N_RAYS; ++$i) {
    my $sd=regular_subdivision($points,$c->RAYS->[$i]);
    my $sdsz=$sd->size();
    print STDERR " $i:$sdsz";
  }
  print STDERR "\n";
}

###
# attention: triangulations unique up to symmetry
# but rays in the same orbit occur several times

$all_rays=load_data("all_rays.data");
$spread=new Array<Int>($all_rays->rows());
for (my $i=0; $i<$all_rays->rows(); ++$i) {
  my $sd=regular_subdivision($points,$M->[$i]);
  $spread->[$i]=$sd->size();
}

# print $spread->size();
# 452
# print histogram($spread);
# {(2 37) (3 161) (4 171) (5 63) (6 20)}

# total number of rays 1633 which come in 223 orbits
