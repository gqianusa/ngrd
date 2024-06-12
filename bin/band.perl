#! /usr/bin/perl
$efermi0=0;
$argc=@ARGV;
if($argc==0){&help();}
if($argc>=2){$efermi0=$ARGV[1];}
if($argc==3){($low_e, $high_e)=split(",",$ARGV[2]);}
open (OUT, ">band.data");
open IN, "$ARGV[0]";
print($argc,$efermi0);
# Begin of Initialization
      $dk=0;
      $ik=0;
      $unit=1;$kl0=0;$kl1=0;$kl2=0;
      @slop0=(0,0,0);
# End of initialization
while(<IN>){
	# Eigenvalues (   eV  ) for nkpt=  48  k points:
  #if(/kpt#(.*), nband=(.*), wtk.*kpt=(.*) .reduced/ and $nk>0){
  if(/kpt#(.*), nband=(.*), wtk.*kpt=(.*)/ ){
	 #kpt#   1, nband= 20, wtk=  1.00000, kpt=  0.6667  0.3333  0.0000 (reduced coord)
    $nb=$2;
    @k1=split " ",$3;
# Begin of one spin
    if($1 == 1){$dk=0;@k0=@k1;
# The second spin
      if($ik >1){
      print OUT "\n\n\n";
      $ik=0;$spin=1;
    }}
    $ik++;
		if($ik==1){$kl0=$dk;}
# Find a kink point 
    $slop1[0]=$k0[0]-$k1[0];
    $slop1[1]=$k0[1]-$k1[1];
    $slop1[2]=$k0[2]-$k1[2];
    $ds=($slop0[0]-$slop1[0])**2+($slop0[1]-$slop1[1])**2+($slop0[2]-$slop1[2])**2;
    $slop0[0]=$slop1[0];
    $slop0[1]=$slop1[1];
    $slop0[2]=$slop1[2];
    if($ds > 0.000001){$kxs[$ikx]=$dk;$ikx++;}
# End of finding a kink point		
    $dk+=sqrt(($k0[0]-$k1[0])**2+($k0[1]-$k1[1])**2+($k0[2]-$k1[2])**2);
    @k0=@k1;
		while($nkb<$nb){
			$_=<IN>;
      $line = $line.$_;
  		$line=~ s/-/ -/g;
  		@eig=split " ",$line;
		  # Split a string into an array of elements with fixed width of 10.
			#@eig = $line =~ m[.{1,10}]g;

  		$neig=@eig;
			$nkb=@eig;
  		$eigens=join " ",@eig;
	  }
    $eigens="";
    #print "$dk	$eigens\n";
  	for($i=0;$i<$neig;$i++){
  		  $eig[$i]*=$unit;
  	}
  		$eigens=join " ",@eig;
			$line="";$nkb=0;
      print OUT "$dk $eigens\n";
  }
	  if(/Eigenvalues(.*)/){
		  $unit=1;$u=$1;
			if($u=~ m/hartree/){$unit=27.2;}
		}
}
		{$kl2=$dk;$kl1=($kl0+$kl2)/2;}
&gpl();
system("gnuplot band.gpl");

# Gnuplot script
sub gpl(){
open GPL, ">band.gpl";
print GPL "#! /usr/bin/env gnuplot
set terminal postscript enhanced eps font 26
set out \"band.eps\"
unset clip points
set clip one
unset clip two
set bar 1.000000 front
set border 31 front linetype -1 linewidth 1.000
set xdata
set ydata
set zdata
set x2data
set y2data
set boxwidth
set style fill  empty border
set style rectangle back fc lt -3 fillstyle   solid 1.00 border lt -1
set style circle radius graph 0.02, first 0, 0 
set dummy x,y
set format x \"% g\"
set format y \"% g\"
set format x2 \"% g\"
set format y2 \"% g\"
set format z \"% g\"
set angles radians
set grid xtics
set key title \"\"
set key inside right top vertical Right noreverse enhanced autotitles nobox
set key noinvert samplen 4 spacing 1 width 0 height 0 
set key maxcolumns 0 maxrows 0
unset label
unset arrow
set style increment default
unset style line
unset style arrow
set style histogram clustered gap 2 title  offset character 0, 0, 0
unset logscale
set offsets 0, 0, 0, 0
set pointsize 1
set pointintervalbox 1
set encoding default
unset polar
unset parametric
unset decimalsign
set view 60, 30, 1, 1
set samples 100, 100
set isosamples 10, 10
set surface
unset contour
set clabel '%8.3g'
set mapping cartesian
set datafile separator whitespace
unset hidden3d
set cntrparam order 4
set cntrparam linear
set cntrparam levels auto 5
set cntrparam points 5
set size ratio 0 1,1
set origin 0,0
set style data points
set style function lines
set xzeroaxis linetype -2 linewidth 1.000
set yzeroaxis linetype -2 linewidth 1.000
set zzeroaxis linetype -2 linewidth 1.000
set x2zeroaxis linetype -2 linewidth 1.000
set y2zeroaxis linetype -2 linewidth 1.000
set ticslevel 0.5
set mxtics default
set mytics default
set mztics default
set mx2tics default
set my2tics default
set mcbtics default
set xtics (\"{/Symbol G}\" ";
print GPL $kl0;
for($i=1;$i<$ikx;$i++){
print GPL ", \"{/Symbol G}\" ";
print GPL $kxs[$i];
}
print GPL ", \"{/Symbol G}\" ";
print GPL $kl2;
print GPL ")
set ytics autofreq  norangelimit
set ztics border in scale 1,0.5 nomirror norotate  offset character 0, 0, 0
set ztics autofreq  norangelimit
set nox2tics
set noy2tics
set cbtics border in scale 1,0.5 mirror norotate  offset character 0, 0, 0
set cbtics autofreq  norangelimit
set title \"\" 
set title  offset character 0, 0, 0 font \"\" norotate
set timestamp bottom 
set timestamp \"\" 
set timestamp  offset character 0, 0, 0 font \"\" norotate
set rrange [ * : * ] noreverse nowriteback  # (currently [8.98847e+307:-8.98847e+307] )
set trange [ * : * ] noreverse nowriteback  # (currently [-5.00000:5.00000] )
set urange [ * : * ] noreverse nowriteback  # (currently [-10.0000:10.0000] )
set vrange [ * : * ] noreverse nowriteback  # (currently [-10.0000:10.0000] )
set xlabel \"K-points\" 
set xlabel  offset character 0, 0.5, 0 font \"\" textcolor lt -1 norotate
set x2label \"\" 
set x2label  offset character 0, 0, 0 font \"\" textcolor lt -1 norotate
set xrange [ * : * ] noreverse nowriteback  # (currently [0.00000:12.0000] )
set x2range [ * : * ] noreverse nowriteback  # (currently [0.00000:11.6428] )
set ylabel \"Energy(eV)\" 
set ylabel  offset character 2, 0, 0 font \"\" textcolor lt -1 rotate by -270
set y2label \"\" 
set y2label  offset character 0, 0, 0 font \"\" textcolor lt -1 rotate by -270
set yrange [ * : * ] noreverse nowriteback  # (currently [-0.600000:-0.350000] )
set y2range [ * : * ] noreverse nowriteback  # (currently [-0.584040:-0.350440] )
set zlabel \"\" 
set zlabel  offset character 0, 0, 0 font \"\" textcolor lt -1 norotate
set zrange [ * : * ] noreverse nowriteback  # (currently [-10.0000:10.0000] )
set cblabel \"\" 
set cblabel  offset character 0, 0, 0 font \"\" textcolor lt -1 rotate by -270
set cbrange [ * : * ] noreverse nowriteback  # (currently [8.98847e+307:-8.98847e+307] )
set zero 1e-08
set lmargin  -1
set bmargin  -1
set rmargin  -1
set tmargin  -1
set locale \"en_US.UTF-8\"
set pm3d explicit at s
set pm3d scansautomatic
set pm3d interpolate 1,1 flush begin noftriangles nohidden3d corners2color mean
set palette positive nops_allcF maxcolors 0 gamma 1.5 color model RGB 
set palette rgbformulae 7, 5, 15
set colorbox default
set colorbox vertical origin screen 0.9, 0.2, 0 size screen 0.05, 0.6, 0 front bdefault
set loadpath 
set fontpath 
set fit noerrorvariables
efermi= $efermi0
set arrow from $kl0,0 to $kl2,0 nohead
plot [:][$low_e:$high_e] for [n=1:$nb] for [m=0:1] \"band.data\" ind m us 1:(column(n+1)-efermi) w point pt 7 ps 0.3 ti \"\" ";
#  for($i=1;$i<$nb;$i++){
#	  $ic=$i+2;
#    print GPL ", \"\" ind 0 us 1:(\$$ic-efermi) w point pt 7 ps 0.3 ti \"\"";
#  }
#	if($spin ==1){
#  print GPL "\\\n";
#  for($i=0;$i<$nb;$i++){
#	  $ic=$i+2;
#    print GPL ", \"\" ind 1 us 1:(\$$ic-efermi) w point pt 7 ps 0.3 lc 1 ti \"\"";
#  }}
}

sub help(){
print "===============================================================
This program is designed to plot band structures through gnuplot
===============================================================
  Usage:
	  $0 file_EIG [E_fermi [Engergy_low,Energy_high]]
where file_EIG is the file with Eigen values.
";
exit;
}
