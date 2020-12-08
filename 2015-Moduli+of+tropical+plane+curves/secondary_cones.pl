#!/bin/bash
# Brodsky, Joswig, Morrison & Sturmfels: Moduli of Plane Tropical Curves
# compute secondary cones; to be called from "Computations".

# prior to using do 'script "gXX/setupYY.pl";' to define the geometric data

use application "fan";
use application "polytope";


print STDERR "secondary_cones g=$genus polytope=$polytope\n";
die "secondary_cones: triangulation file $triangulations_file not found" unless -e $triangulations_file;

# FIXME: spurios data at beginning of first line of triangulations file
open (TOPCOM, "<:encoding(UTF-8)", "$triangulations_file");
declare @T=(); foreach (<TOPCOM>) { chomp; push @T, new Array<Set>(eval($_)); }
close TOPCOM;

foreach my $b (@all_buckets) {
    # read bucket file
    my $thisbucketfile="$buckets_dir/numG_$b.txt";
    die "secondary_cones: bucket file $thisbucketfile not found" unless -e $thisbucketfile;
    open BUCKET, "$buckets_dir/numG_$b.txt";
    my @B=(); foreach (<BUCKET>) { chomp; push @B, $_; }
    close BUCKET;

    my $thisbucketname="$prefix"."b$b";
    my $thisbucketdir="$wd_path/$thisbucketname";
    print "bucket: ", $thisbucketdir, "\n"; 
    if(!`[ -d $thisbucketdir ] && echo "exists"`){mkdir $thisbucketdir;} 
    chdir $thisbucketdir;
    my $bucket_ids=new Array<Int>(@B);
    save_data($bucket_ids,"$thisbucketname-ids.dat");#old: save_data($bucket_ids,"$thisbucketname-ids.dat","bucket_ids g=$genus polytope=$polytope");
    foreach my $id (@B) {
        print STDERR "$id ";
        my $is_reg=is_regular($points,$T[$id],lift_to_zero=>$frame);        
        my $subdiv = new fan::SubdivisionOfPoints(POINTS=>$points,WEIGHTS=>$is_reg->second);
        my $sec = $subdiv->secondary_cone;        
        $sec->name=join("","$thisbucketname-$id");
        $sec->attach("ID",$id);
        $sec->attach("BUCKET",$b);
        $sec->attach("POLYTOPE",$polytope);
        $sec->attach("GENUS",$genus);
        $sec->attach("INDUCED_TRIANGULATION",$T[$id]);
        my $conepath =  join("",$thisbucketname,"-",$id,".cone");
        if(`[ -f $conepath ] && echo "exists"`){
            `rm $thisbucketname-$id.cone`;
            print $conepath, " gets updated\n";}
        save $sec
    }
    chdir "../../..";
    print STDERR "\n";
}

# Local Variables:
# mode: cperl
# c-basic-offset:2
# End:

