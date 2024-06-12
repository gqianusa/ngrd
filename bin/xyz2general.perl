#! /usr/bin/perl
# The program is designed to generate .dx file from .xyz
#  @Gefei Qian
# Features:
open IN,"$ARGV[0]";
open OUT,">$ARGV[1]";
$_=<IN>;
$na=$_;
close IN;
&outdx();
close OUT;
#
sub outdx(){
print OUT "
file = $ARGV[0]
points = $na
format = ascii
interleaving = field
header = lines 2
field = type, locations
structure = scalar, 3-vector
type = int, float

end
";
close OUT;
}
