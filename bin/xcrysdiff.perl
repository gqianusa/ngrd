#!  /usr/bin/perl
$argc=@ARGV;
if($argc!=3){&usage();}
$t_file=$ARGV[0];
$f_file=$ARGV[1];
$s_file=$ARGV[2];
#print "$t_file;$f_file;$s_file\n";
open TOT,"$t_file" or &usage();
open FIR,"$t_file" or &usage();
open SEC,"$t_file" or &usage();
open OUT,">xcry_diff.xsf" or die;
$_=<TOT>;$f=<FIR>;$s=<SEC>;
#The whole system
  for($i=0;$i<7;$i++){
    print OUT $_;
    $_=<TOT>;
    $f=<FIR>;$s=<SEC>;
  }
  ($natom,$ni)=split " ",$_;
  print "Total atoms: $natom\n";
  $lines=$natom*2+9;
  for($i=0;$i<$lines;$i++){
    print OUT $_;
    $_=<TOT>;
  }
    print OUT $_;
#The first system
  ($natom,$ni)=split " ",$f;
  print "Number of atoms in the first system: $natom\n";
  $lines=$natom*2+9;
  for($i=0;$i<$lines;$i++){
    $_=<FIR>;
  }
#The second system
  ($natom,$ni)=split " ",$f;
  print "Number of atoms in the second system: $natom\n";
  $lines=$natom*2+9;
  for($i=0;$i<$lines;$i++){
    $_=<SEC>;
  }
while(<TOT>){
    $f=<FIR>;$s=<SEC>;
  if(!($_ =~ m/END/)){
    @data=split " ",$_;
    @f_data=split " ",$f;
    @s_data=split " ",$s;
    $tline=@data;
    for($i=0;$i<$tline;$i++){
      $diff=$data[$i]-$f_data[$i]-$s_data[$i];
#print "$_;$f;$s;\n$diff=$data[$i]-$f_data[$i]-$s_data[$i]";
      printf OUT '%20.5E  ',$diff;
      #print OUT "$diff_s";
#exit;
    }
    print OUT "\n";
  }else{print OUT "$_";}
}

sub usage(){
print "The program $0 is designed to calculate electron density transfer
     By Gefei Qian 08/10/2017
Usage: $0 file_total_xsf first_xsf second_xsf
	The final xcrysden file of electron density transfer is 
     in xcrys_diff.xsf You need to rename this file before your run
     another $0 in this directory.
";
exit;
}
