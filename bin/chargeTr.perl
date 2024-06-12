#! /usr/bin/perl
# This program is designed to compbine .dx files with same dimensions into one .dx files.
# @Gefei Qian 2013
# Features added:
#   1) unlimited input files
#   2) Adding shift
#   3) adding multipulation
#==================================
#defaults:
@multi=(1,1,1);
$argc=@ARGV;
if($argc==0){&help();}
foreach(@ARGV){
  if(/^\+/){
    push @oper,"+";
    substr $_, 0, 1, "";
    push @files,$_;
  }elsif(/^-/) {
    push @oper,"-";
    substr $_, 0, 1, "";
    push @files,$_;
  }elsif(/^>/ and $oflag==0) {
    push @oper,"-";
    substr $_, 0, 1, "";
    $out=$_;
    $oflag=1;
  }elsif(/^\@/) {
    substr $_, 0, 1, "";
    @multi= split ",",$_;
  }else{
    @shift=split ",",$_;
  }
}
# not enough file names
$nf=@files;
if($nf<2){&help();}
if($oflag==0){&help();}

open OUT,">$out";
open FILE1,"$files[0]";
#
# The first density file
$dpoint=0;
while(<FILE1>){
  $v1=$_;
  if(/object 1 class gridpositions counts  *(\d*)  *(\d*)  *(\d*)/){
    $nz=$1;$ny=$2;$nx=$3;
    $mnz=$multi[2]*$1;$mny=$multi[1]*$2;$mnx=$multi[0]*$3;
    $mtotal=$mnx*$mny*$mnz;
    $mxy=$mnx*$mny;
    $nyz=$ny*$nz;
    $nxy=$ny*$nx;
    #print "$nx ;$ny; $nz\n";exit;
  }
  if(/[a-z]/){
    if($dflag!=1){
      if(/(.*counts )/){
        print OUT "$1 $mnz $mny $mnx\n";
      }elsif(/(.*items) .* (data .*)/){
        print OUT "$1 $mtotal $2\n";
      }else{
        print OUT;
      }
    }
    else{$ending.=$_;}
  }else{
    &shift();
    if($oper[0] eq "+"){$value[$idpoint]=$v1;}
    if($oper[0] eq "-"){$value[$idpoint]=-$v1;}
    #print "$value[$dpoint] $oper[0]\n";exit;
    $dpoint++;
  }
  if($v1 =~ m/ (\d{1,})  *data follows/){$np1=$1;$dflag=1;}
}

for($ifile=1;$ifile<$nf;$ifile++){
  open FILE2,$files[$ifile];
  $dpoint=0;
  $d1flag=0;
  while(<FILE2>){
    $v2=$_;
    if($d1flag==1){
      &shift();
      if($oper[$ifile] eq "+"){$value[$idpoint]+=$v2;}
      if($oper[$ifile] eq "-"){$value[$idpoint]-=$v2;}
      #print "$value[$dpoint] $oper[0]\n";exit;
      $dpoint++;
    }
    if($v2 =~ m/ (\d{1,})  *data follows/){
      $np2=$1;$d1flag=1;
      if($np1!=$np2){
        print "The data point number on $files[$ifile] is different $np1 $np2!\n";exit;
      }
    }
  }
}
#Output data points
for($id=0;$id<$mtotal;$id++){
  $ix=$id%$nx;
  $iy=int($id/$mnx)%$ny;
  $iz=int($id/$mxy)%$nz;
  $id1=($iz*$ny+$iy)*$nx+$ix;
  print OUT "$value[$id1]\n";
}
print OUT $ending;


#Usage
sub help(){
print " A program designed to manipulate .dx files, with option to multiple the field in mesh directions.
---- Too few file names----
  Usage:
    $0 [+,-]input1 [+,-]input2 [[+,-]inputs] [\@repetition] \\>output
You need at least two input files.
Default repetition is (1,1,1) in mesh unit vector directions.
";
exit;
}

# Shift the mesh
sub shift(){
    $ix=$dpoint%$nx;
    $iy=($dpoint/$nx)%($ny);
    $iz=int($dpoint/($nxy));
#print "$ix;$iy;$iz\n";
    $nix=($shift[0]*$nx+$ix)%$nx;
    $niy=($shift[1]*$ny+$iy)%$ny;
    $niz=($shift[2]*$nz+$iz)%$nz;
    $idpoint=$nix+($niy+$niz*$ny)*$nx;
    $dd=$dpoint-$idpoint;
}
