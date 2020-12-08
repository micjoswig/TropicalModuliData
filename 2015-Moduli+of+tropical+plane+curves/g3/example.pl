# various snippets of useful polymake code

# print primal edges
$Sigma=$c->get_attachment("TRIANGULATION");
$de_array=$c->get_attachment("DUAL_EDGE_ARRAY");
for (my $e=0; $e<18; ++$e) {
  my ($a,$b)=($de_array->[$e]->[0],$de_array->[$e]->[-1]);
  print "$e: ", $Sigma->[$a]*$Sigma->[$b], "\n";
}
