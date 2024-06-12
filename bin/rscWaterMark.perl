#!  /usr/bin/perl
$aps=@ARGV;
if($aps!=2){&help();}
open IN, "$ARGV[0]" or &help();
open OU, ">$ARGV[1]" or &help();
while(<IN>){
	$_=~ s/View Article Online//;
	$_=~ s/ \/ Journal Homepage//;
	$_=~ s/ \/ Table of Contents for this issue//;
  if(/^.Published on .* Stanford/){$_="(";print OU;
	  $_=<IN>;$_=~ s/.* \)/\)/;print OU;
	}elsif(/^\(Dynamic\)/){
	  for($i=0;$i<11;$i++){$_=<IN>;}
	}else{print OU;}
}

sub help(){
print "
=========================
removing watermarks from a rsc postscript file.
  Usage:
	   $0 in.ps out.ps
=========================
";
exit;
}
