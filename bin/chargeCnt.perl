#! /usr/bin/perl
# This program is designed to layer charge transfer from a .dx file resulting from chargeTr.perl
# @Gefei Qian 2014
# 
#==================================
#defaults:
$lower=0;
$upper=1;
$positive=0;
$negative=0;
# commandline options
$argc=@ARGV;
if($argc!=3){&help();}
$lower=$ARGV[0];
$upper=$ARGV[1];
$file=$ARGV[2];

open FILE1,$file or &help();
#
# The first density file
$dpoint=0;
while(<FILE1>){
  $v1=$_;
  if(/object 1 class gridpositions counts  *(\d*)  *(\d*)  *(\d*)/){
    $nz=$1;$ny=$2;$nx=$3;
    $nxy=$ny*$nx;
    $nxyz=$nxy*$nz;
		$nz0=int($nz*$lower);
		$nz1=int($nz*$upper);
    #print "$nx ;$ny; $nz\n";exit;
  }
  if(/^delta(.*)/){
	  $d.=$1;
  }
  if(/data follows/){
	  @s=split " ",$d;
		#print "@s  "; print "\n";
		$volume=$s[2]*($s[3]*$s[7]-$s[4]*$s[6]);
		#print"$volume=$s[2]*($s[3]*$s[7]-$s[4]*$s[6])\n";
		$volume=abs($volume);
		#print "$volume\n";
		@sc=@s/0.529177210;
		$sc[2]*=$nz;
		$sc[3]*=$nx;
		$sc[4]*=$ny;
		$sc[6]*=$nx;
		$sc[7]*=$ny;
		#print "@sc\n";
    for($iz=0;$iz<$nz;$iz++){
		  for($ixy=0;$ixy<$nxy;$ixy++){
			  $_=<FILE1>;
				if($iz<=$nz1 and $iz>=$nz0){
				  if($_ > 0){$positive+=$_;}
					if($_ < 0){$negative+=$_;}
					#print "$positive $negative\n";
					#exit;
				}
			}
		}
  }
}
$ratio=$volume/0.529177210**3;
$positive *=$ratio;
$negative *=$ratio;
$net=$positive+$negative;
#Output data points
print "Between $lower and $upper, in unit of electron, total positive charge is $positive,
negative charge is $negative. Net charge is $net.
";

#Usage
sub help(){
print " A program designed to calculate charge transfer in a region between start_layer and end_layer in z-direction, where 0 means bottom and 1 the top.
---- Incorrect options ----
  Usage:
    $0 start_layer end_layer charge.dx
";
exit;
}
