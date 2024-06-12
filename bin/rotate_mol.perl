#! /usr/bin/perl
# This program is designed for NGRD Summer school
#  @ Gefei Qian Aug 2014
#==============================================
$argc=@ARGV;
if($argc != 5){&help();}
$o=$ARGV[0];
$o--;
$axis=$ARGV[1];
$phi=$ARGV[2]*3.14159265/180;

$infile=$ARGV[3];
$outfile=$ARGV[4];

open IN,"<$infile" or &help();
open OUT,">$outfile" or &help();
$n=<IN>;
print OUT "$n\n";
$_=<IN>;
for($i=0;$i<$n;$i++){
  $_=<IN>;
	($ele[$i],$x[$i],$y[$i],$z[$i])=split " ",$_;
}
@oxyz=($x[$o], $y[$o],$z[$o]);

for($i=0;$i<$n;$i++){
  @x123=($x[$i],$y[$i],$z[$i]);
	for($j=0;$j<3;$j++){$x123[$j] -= $oxyz[$j];}
	if($axis == 1){
	  $y123[1]=cos($phi)*$x123[1]-sin($phi)*$x123[2];
	  $y123[2]=sin($phi)*$x123[1]+cos($phi)*$x123[2];
		$y123[0]=$x123[0];
	}
	if($axis == 2){
	  $y123[2]=cos($phi)*$x123[2]-sin($phi)*$x123[0];
	  $y123[0]=sin($phi)*$x123[2]+cos($phi)*$x123[0];
		$y123[1]=$x123[1];
	}
	if($axis == 3){
	  $y123[0]=cos($phi)*$x123[0]-sin($phi)*$x123[1];
	  $y123[1]=sin($phi)*$x123[0]+cos($phi)*$x123[1];
		$y123[2]=$x123[2];
	#print "@y123\n";
	}
	for($j=0;$j<3;$j++){$y123[$j] += $oxyz[$j];}
  print OUT "$ele[$i]	$y123[0]	$y123[1]	$y123[2]\n";
}
print " Congratulation! A molecule after rotation is saved in $outfile.

";

sub help(){
print "Program to rotate a molecule in in.xyz, and save the result in out.xyz.
	Usage:
		$0 origin_atom_index axis angle_in_degree in.xyz out.xyz
	where axis takes 1,2,3 for x-,y-,and z-axis
";
exit;
}
