#! /usr/bin/perl
# This program is designed to extract atomic positions from abinit out files
# By Dr. Gefei Qian @2013
#   Features:
#     1) multiply the cells in cell directions;
#     2) shift atoms within cell directions;
#==========
#Default shift
@shift=(0,0,0);
$argc=@ARGV;
if($argc==2){@shift=split ",",$ARGV[1];}
if(!(open IN, "<$ARGV[0]")){&header();}
$_=<IN>;
chomp;
($nx,$ny,$nz)=split (" ");
$_=<IN>;
chomp;
$outDX=$_;
$_=<IN>;
chomp;
$outXYZ=$_;
$_=<IN>;
chomp;
$multi=$_;
close IN;
$struct=0;
if(!(open OUT, ">$multi")){&header();}
# Find rprim
if(!(open IN, "<$outDX")){&header();}
$_=<IN>;chomp;
$_=~ s/.*counts//;
@mxyz=split " ",$_;
$_=<IN>;chomp;
$_=<IN>;chomp;
$_=~ s/.*delta//;
@dxyz=split " ",$_;
for($i=0;$i<3;$i++){$a1[$i]=$mxyz[2-$i]*$dxyz[$i];}
$_=<IN>;chomp;
$_=~ s/.*delta//;
@dxyz=split " ",$_;
for($i=0;$i<3;$i++){$a2[$i]=$mxyz[2-$i]*$dxyz[$i];}
$_=<IN>;chomp;
$_=~ s/.*delta//;
@dxyz=split " ",$_;
for($i=0;$i<3;$i++){$a3[$i]=$mxyz[2-$i]*$dxyz[$i];}
close IN;
#
# Determinant
# in .dx file, the components are arranged in z,y,x
$det=$a3[0]*$a2[1]*$a1[2];
$det+=$a3[1]*$a2[2]*$a1[0];
$det+=$a3[2]*$a2[0]*$a1[1];
$det-=$a3[0]*$a2[2]*$a1[1];
$det-=$a3[1]*$a2[0]*$a1[2];
$det-=$a3[2]*$a2[1]*$a1[0];
# Inverse of rprim for shifting;
#
$b1[0]=($a2[1]*$a1[2]-$a2[2]*$a1[1])/$det;
$b1[1]=($a2[2]*$a1[0]-$a2[0]*$a1[2])/$det;
$b1[2]=($a2[0]*$a1[1]-$a2[1]*$a1[0])/$det;
#
$b2[0]=($a1[1]*$a3[2]-$a1[2]*$a3[1])/$det;
$b2[1]=($a1[2]*$a3[0]-$a1[0]*$a3[2])/$det;
$b2[2]=($a1[0]*$a3[1]-$a1[1]*$a3[0])/$det;
#
$b3[0]=($a3[1]*$a2[2]-$a3[2]*$a2[1])/$det;
$b3[1]=($a3[2]*$a2[0]-$a3[0]*$a2[2])/$det;
$b3[2]=($a3[0]*$a2[1]-$a3[1]*$a2[0])/$det;
#
# &print_matrix();
# Find atomic positions
if(!(open IN, "<$outXYZ")){&header();}
#
$na=<IN>;
$nm=$na*$nx*$ny*$nz;
$_=<IN>;
print OUT "$nm\n .xyz file for DX from DEN\n";
for($ia=0;$ia<$na;$ia++){
  $_=<IN>;
  @line=split " ",$_;
	$nucl=$line[0];shift @line;
  # xangst to xred
	  $xyz[0]=0;
  	for($j=0;$j<3;$j++){
	    $xyz[0]+=$line[$j]*$b1[$j];
  	}
	  $xyz[1]=0;
  	for($j=0;$j<3;$j++){
	    $xyz[1]+=$line[$j]*$b2[$j];
  	}
	  $xyz[2]=0;
  	for($j=0;$j<3;$j++){
	    $xyz[2]+=$line[$j]*$b3[$j];
  	}

#print "@line;@xyz\n";
# shifting
  for($ix=0;$ix<3;$ix++){
						  $temp=$xyz[$ix]+$shift[$ix];
						  $tempi=int($temp);
						  $xyz[$ix]=$temp-$tempi;
	}
  &multiply();
}
      print OUT "\n\n";
close IN;
close out;
print "$0 is finished !!
The final atomic structure is saved in $multi.
";

sub multiply(){
local $i,$j,$k,$ix;
  for($i=0;$i<$nx;$i++){
    for($j=0;$j<$ny;$j++){
      for($k=0;$k<$nz;$k++){
        for($ix=0;$ix<3;$ix++){
          $out[$ix]=($xyz[0]+$i)*($a3[$ix])+($xyz[1]+$j)*($a2[$ix])+($xyz[2]+$k)*($a1[$ix]);
        }
#          $nucl=int($znucl[$typat[$ia]]);
          #print "@typat @znucl $nucl\n";
        #  $symb=$ele[$nucl];
        print OUT "$nucl @out\n";
      }
    }
  }
}

sub header(){
print" $ele[2]
   Usage: $0 input_file shifts
     where input_file has a line of three numbers of cell repetition
     in each rprim direction, .dx file and .xyz file generated from cut3d,
		 and .xyz file to save the atomic structure.
		 Optional shift comprise a string of dx,dy,dz.
";
exit;
}

sub elements(){
@ele=(null,H,He,Li,Be,B,C,N,O,F,Ne,Na,Mg,Al,Si,P,S,Cl,Ar,K,Ca,Sc,Ti,V,Cr,Mn,Fe,Co,Ni,Cu,Zn,Ga,Ge,As,Se,Br,Kr,Rb,Sr,Y,Zr,Nb,Mo,Tc,Ru,Rh,Pd,Ag,Cd,In,Sn,Sb,Te,I,Xe,Cs,Ba,La,Ce,Pr,Nd,Pm,Sm,Eu,Gd,Tb,Dy,Ho,Er,Tm,Yb,Lu,Hf,Ta,W,Re,Os,Ir,Pt,Au,Hg,Tl,Pb,Bi,Po,At,Rn,Fr,Ra,Ac,Th,Pa,U,Np,Pu,Am,Cm,Bk,Cf,Es,Fm,Md,No,Lr,Rf,Db,Sg,Bh,Hs,Mt,Ds,Rg,Cn,Uut,Fl,Uup,Lv,Uus,Uuo);
}

sub print_matrix(){
print "A\n@a3\n@a2\n@a1\n====\nB\n";
print "@b1\n@b2\n@b3\n====\nUnity\n";
  $no=0;
  for($i1=0;$i1<3;$i1++){
	  $no+=$a3[$i1]*$b1[$i1];
  } print "$no ";
  $no=0;
  for($i1=0;$i1<3;$i1++){
	  $no+=$a3[$i1]*$b2[$i1];
  } print "$no ";
  $no=0;
  for($i1=0;$i1<3;$i1++){
	  $no+=$a3[$i1]*$b3[$i1];
  } print "$no\n";
  $no=0;
  for($i1=0;$i1<3;$i1++){
	  $no+=$a2[$i1]*$b1[$i1];
  } print "$no ";
  $no=0;
  for($i1=0;$i1<3;$i1++){
	  $no+=$a2[$i1]*$b2[$i1];
  } print "$no ";
  $no=0;
  for($i1=0;$i1<3;$i1++){
	  $no+=$a2[$i1]*$b3[$i1];
  } print "$no\n";
  $no=0;
  for($i1=0;$i1<3;$i1++){
	  $no+=$a1[$i1]*$b1[$i1];
  } print "$no ";
  $no=0;
  for($i1=0;$i1<3;$i1++){
	  $no+=$a1[$i1]*$b2[$i1];
  } print "$no ";
  $no=0;
  for($i1=0;$i1<3;$i1++){
	  $no+=$a1[$i1]*$b3[$i1];
  } print "$no\n";
exit;
}
