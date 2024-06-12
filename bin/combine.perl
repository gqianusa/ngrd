#! /usr/bin/perl
$argc=@ARGV;
if($argc<4){&help();}
open OUT, ">$ARGV[3]";
open IN1, "$ARGV[0]";
open IN2, "$ARGV[1]";
$shift=$ARGV[2];
$natom1=<IN1>;
chomp $natom1;
$natom2=<IN2>;
chomp $natom2;
$n_total=$natom1+$natom2;
print OUT  "$n_total
combined
";
$_=<IN1>;
$_=<IN2>;
while(<IN1>){
print OUT $_;
}
close IN1;
while(<IN2>){
@line=split " ",$_;
$line[3] += $shift;
print OUT "$line[0]  $line[1]  $line[2]  $line[3]
";
}
sub help(){
print "===============================================================
This program is designed to combine two .xyz molecues into one
===============================================================
  Usage:
          $0 first.xyz second.xyz shift output.xyz
";
exit;
}
