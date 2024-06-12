#! /usr/bin/perl
# Generatting single layer honeycomb sheet
# Gefei Qian 07/13/2013
# Usage: honeycomb.perl rep_x rep_y
#
#
use Math::BigRat;

$argc=@ARGV;
if($argc != 2){&header();}
$n1=$ARGV[0];
$n2=$ARGV[1];

for($i1=0;$i1<$n1;$i1++){
for($i2=0;$i2<$n2;$i2++){
  $deci=Math::BigRat->new('1/3');
  $deci+=$i1;
  $deci/=$n1;
  print "$deci ";

  $deci=Math::BigRat->new('1/3');
  $deci+=$i2;
  $deci/=$n2;
  print "$deci 0\n";

  $deci=Math::BigRat->new('2/3');
  $deci+=$i1;
  $deci/=$n1;
  print "$deci ";

  $deci=Math::BigRat->new('2/3');
  $deci+=$i2;
  $deci/=$n2;
  print "$deci 0\n";

}}

sub header(){
print "Usage:
    $0 rep_x rep_y
";
exit;
}
