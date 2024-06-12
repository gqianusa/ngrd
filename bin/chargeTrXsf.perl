#!  /usr/bin/perl
# This program is designed to combine charge tranfer fron .xsf files
# @Gefei Qian 2019
#==================================
#
$argc=@ARGV;
if($argc ne 4){&help();}
#print @ARGV;
#
open TOT, $ARGV[0] or &help();
open M1, $ARGV[1] or &help();
open M2, $ARGV[2] or &help();
open DIFF, ">$ARGV[3]" or &help();
$d3=0;
for($i=0;$i<8;$i++){
   $s=<TOT>;
   print DIFF $s;
   @line=split" ",$s;
   $ta=$line[0];
   $s=<M1>;
   @line=split" ",$s;
   $m1a=$line[0];
   $s=<M2>;
   @line=split" ",$s;
   $m2a=$line[0];
}
#print "$ta $m1a $m2a \n";
$th=2*$ta+9;
for($i=0;$i<$th;$i++){
   $s=<TOT>;
   print DIFF $s;
}
$th=2*$m1a+9;
for($i=0;$i<$th;$i++){
   $_=<M1>;
   #print $_;
}
#print "M2\n";
$th=2*$m2a+9;
for($i=0;$i<$th;$i++){
   $s=<M2>;
   #print $_;
}
$d3=0;
while(<TOT>){
  if(/END_DATAGRID_3D/){
    $d3=1;
  }
  if($d3 eq 1){
    print DIFF $_;
  }
  if($d3==0){
    @t=split(" ",$_);
#    print "t:$_";
    $_=<M1>;
#    print "m1:$_";
    @m1=split(" ",$_);
    $_=<M2>;
#    print "m2:$_";
    @m2=split(" ",$_);
    #exit;
    $l=@t;
    for ($i=0;$i<$l;$i++){
      $ddd=$t[$i]-$m1[$i]-$m2[$i];
      printf(DIFF '%20.5E',$ddd);
    }
    print DIFF  "\n";
  }
}
print "The charge transfer is successfully output to file $ARGV[3]\n";
#Usage
sub help(){
print " A program designed to manipulate .xsf files to produce charge tranfer for XCryDen rendering. You can get individual .xsf files by running cut_3d against corresponding .DEN files.
  Usage:
    $0 total_charge.xsf first_charge.xsf second_charge.xsf charge_tr.xsf
";
exit;
}

