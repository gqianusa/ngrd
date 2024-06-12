#! /usr/bin/perl
# The program is designed to generate .dx file from .xyz
#  @Gefei Qian
# Features:
$argc=@ARGV;
if($argc!=2){&help();}
&hash();
open IN,"<$ARGV[0]";
open OUT,">$ARGV[1]";
$_=<IN>;
$na=$_*1.0;
$_=<IN>;
$ine=0;
for($i=0;$i<$na;$i++){
 $_=<IN>;
 @line=split " ",$_;
 #$elem[$i]=$znucl{$line[0]};
 $elem[$i]=$line[0];
 @at=@line[1..3];
 $pos[$i]=join " ",@at;
# shift @line; shift @line; shift @line; shift @line;
# $ne=@line;
# for($j=0;$j<$ne;$j++){
#   $neib[$i]=join " ",($i,$line[$j]-1);
#	 $ine++;
# }
}
close IN;
for($i=0;$i<$na;$i++){
	@aa=split " ", $pos[$i];
	$ra=$radii[$elem[$i]];
  for($j=$i+1;$j<$na;$j++){
	  @ab=split " ", $pos[$j];
		$rr=0;
	  $rb=$radii[$elem[$j]];
	  for($k=0;$k<3;$k++){$rr+=($aa[$k]-$ab[$k])**2;}
		$rc=($ra+$rb)/2;
		$rr=sqrt($rr);
#		print "$i $j $ra $rb $rr\n";
		if($rr<$rc){$ne=join " ",($i,$j);push @neib, $ne;}
  }
}
&outdx();
close OUT;
#
#atomic structure
sub outdx(){
print OUT "#
object 1 class array type float rank 1 shape 3 items $na data follows
";
for($i=0;$i<$na;$i++){
 print OUT "$pos[$i]\n";
}
print OUT "#
#atom types
object 2 class array type float rank 0 items $na data follows
";
for($i=0;$i<$na;$i++){
 print OUT "$elem[$i] ";
}
 print OUT "\nattribute \"dep\" string \"positions\" 
#atom types
object 3 class array type float rank 0 items $na data follows
";
for($i=0;$i<$na;$i++){
 print OUT "$radii[$elem[$i]] ";
}
$na=@neib;
 print OUT "\nattribute \"dep\" string \"positions\" 
# Bonds
object 4 class array type int rank 1 shape 2 items $na data follows
";
for(@neib) {
 print OUT "$_\n";
}
 print OUT"#
attribute \"element type\" string \"lines\"
attribute \"ref\" string \"positions\"
# structure
object \"default\" class field
component \"positions\" value 1
component \"data\" value 2
component \"size\" value 3
component \"connections\" value 4
end
";
close OUT;
}
# Hash back
sub hash(){
&elements();
$tele=@ele;
  for($i=0;$i<$tele;$i++){
	    $znucl{$ele[$i]}=$i;
	}
}

sub elements(){
@ele=(null,H,He,Li,Be,B,C,N,O,F,Ne,Na,Mg,Al,Si,P,S,Cl,Ar,K,Ca,Sc,Ti,V,Cr,Mn,Fe,Co,Ni,Cu,Zn,Ga,Ge,As,Se,Br,Kr,Rb,Sr,Y,Zr,Nb,Mo,Tc,Ru,Rh,Pd,Ag,Cd,In,Sn,Sb,Te,I,Xe,Cs,Ba,La,Ce,Pr,Nd,Pm,Sm,Eu,Gd,Tb,Dy,Ho,Er,Tm,Yb,Lu,Hf,Ta,W,Re,Os,Ir,Pt,Au,Hg,Tl,Pb,Bi,Po,At,Rn,Fr,Ra,Ac,Th,Pa,U,Np,Pu,Am,Cm,Bk,Cf,Es,Fm,Md,No,Lr,Rf,Db,Sg,Bh,Hs,Mt,Ds,Rg,Cn,Uut,Fl,Uup,Lv,Uus,Uuo);
@radii=(null,1.2,1.4,1.82,1.53,1.92,1.7,1.55,1.52,1.47,1.54,2.27,1.73,1.84,2.1,1.8,1.8,1.75,1.88,2.75,2.31,2.11,1.47,1.34,1.28,1.27,1.26,1.25,1.63,1.4,1.39,1.87,2.11,1.85,1.9,1.85,2.02,3.03,2.49,1.8,1.6,1.46,1.39,1.36,1.34,1.34,1.63,1.72,1.58,1.93,2.17,2.06,2.06,1.98,2.16,3.43,2.68,1.87,1.818,1.824,1.814,1.834,1.804,1.804,1.804,1.773,1.781,1.762,1.761,1.759,1.76,1.738,1.59,1.46,1.39,1.37,1.35,1.355,1.75,1.66,1.55,1.96,2.02,2.07,1.97,2.02,2.2,3.48,2.83,1.80,1.79,1.63,1.86,1.55,1.59,1.73,1.74,1.7,1.86,1.86,1.8,1.8,1.8,1.8,1.31,1.26,1.21,1.19,1.18,1.13,1.12,1.18,1.3,1.8,1.8,1.8,1.8,1.8,1.8);
}
#
sub help(){
print"=========================
This program converta . xyz file to a .dx file.
   Usage: $0 file.xyz file.dx
     where file.xyz contains atomic structures to be shown in dx with file.dx.
";
exit;
}
