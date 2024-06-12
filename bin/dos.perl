#! /usr/bin/perl
$argc=@ARGV;
if($argc!=3){&help();}
$file=$ARGV[2];
$npoints=$ARGV[0];
$energy[$npoints-1]=0;
$dos[$npoints-1]=0;
($e0,$e1)=split ",", $ARGV[1];
#
$de=($e1-$e0)/$npoints;
$de22=$de*$de*16;
for($i=0;$i<$npoints;$i++){
   $energy[$i]=$de*$i+$e0;
	 $dos[$i]=0;
}
#print "$e0, $e1, $npoints, $file, @energy\n";
#
open OUT, ">dos.data";
      $dk=0;
      $ik=0;
open IN, "$file" or &help();
$unit=1;$kl0=0;$kl1=0;$kl2=0;
while(<IN>){
	# Eigenvalues (   eV  ) for nkpt=  48  k points:
  #if(/kpt#(.*), nband=(.*), wtk.*kpt=(.*) .reduced/ and $nk>0){
  if(/kpt#(.*), nband=(.*), wtk= (.*), kpt=(.*)/ ){
	 #kpt#   1, nband= 20, wtk=  1.00000, kpt=  0.6667  0.3333  0.0000 (reduced coord)
    $nb=$2;
		$wk=$3;
    @k1=split " ",$4;
# Begin of one spin
    if($1 == 1){$dk=0;@k0=@k1;
# The second spin
      if($ik >1){
      print OUT "\n\n\n";
      $ik=0;$spin=1;
    }}
    $ik++;
		if($ik==1){$kl0=$dk;}
    $dk+=sqrt(($k0[0]-$k1[0])**2+($k0[1]-$k1[1])**2+($k0[2]-$k1[2])**2);
    @k0=@k1;
		while($nkb<$nb){
			$_=<IN>;
      $line = $line.$_;
  		#@eig=split " ",$line;
		  # Split a string into an array of elements with fixed width of 10.
			@eig = $line =~ m[.{1,10}]g;

  		$neig=@eig;
			$nkb=@eig;
  		$eigens=join " ",@eig;
	  }
    for($j=0;$j<$nkb;$j++){
		  $eig[$j]*=$unit;
		}
    for($i=0;$i<$npoints;$i++){
    for($j=0;$j<$nkb;$j++){
		  $dos[$i]+=exp(-($eig[$j]-$energy[$i])**2/$de22)/$ik*$wk;
		}
		}
		#
			$line="";$nkb=0;
  }
	  if(/Eigenvalues(.*)/){
		  $unit=1;$u=$1;
			if($u=~ m/hartree/){$unit=27.2;}
		}
}
		{$kl2=$dk;$kl1=($kl0+$kl2)/2;}
for($i=0;$i<$npoints;$i++){
  print OUT "$dos[$i] $energy[$i] \n";
}

&gpl();
system("gnuplot dos.gpl");
print "Your DOS plot is saved in dos.eps.\n";

# Gnuplot script
sub gpl(){
open GPL, ">dos.gpl";
print GPL "#! /usr/bin/gnuplot
set terminal postscript enhanced eps font 26
set out \"dos.eps\"
unset xtic
efermi=0
plot \"dos.data\" with lin ti \"\"
";
}

sub help(){
print "===============================================================
This progran is designed to plot DOS through gnuplot
===============================================================
  Usage:
	  $0 n_points e1,e2 file_EIG
where n_points is the data points in the plot and e1,e2 are the lower energy and upper energy, 
	and file_EIG is the file with Eigen values.
";
exit;
}
