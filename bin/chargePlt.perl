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
if($argc!=1){&help();}
$file=$ARGV[0];
$out="charge.dat";

open FILE1,$file or &help();
open FI,">$out" or &help();
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
$ratio=$volume/0.529177210**3;
		#print "$volume\n";
		@sc=@s/0.529177210;
		$sc[2]*=$nz;
		$sc[3]*=$nx;
		$sc[4]*=$ny;
		$sc[6]*=$nx;
		$sc[7]*=$ny;
		#print "@sc\n";
    for($iz=0;$iz<$nz;$iz++){
			$c=0;
		  for($ixy=0;$ixy<$nxy;$ixy++){
			  $_=<FILE1>;
				$c+=$_;
				if($iz<=$nz1 and $iz>=$nz0){
				  if($_ > 0){$positive+=$_;}
					if($_ < 0){$negative+=$_;}
					#print "$positive $negative\n";
					#exit;
				}
			}
			$cz=$iz*1.0/$nz;
			$c*=$ratio;
			print FI "$cz	$c\n";
		}
  }
}
close FI;

open FI, ">charge.gpl";
print FI "set term postscript enh eps
set out \"charge.eps\"
set yzeroa
plot \"charge.dat\" us 2:1 w line ti \"\"
";
close FI;
system("gnuplot charge.gpl");
$positive *=$ratio;
$negative *=$ratio;
$net=$positive+$negative;
#Output data points
print "Your charge profile graph is saved in charge.eps\n";


#Usage
sub help(){
print " A program designed to plot charge profile in z-direction.
---- Incorrect options ----
  Usage:
    $0 charge.dx
";
exit;
}
