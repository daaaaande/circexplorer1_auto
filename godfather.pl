#/usr/bin/perl -w
use strict;

system("clear");

open(ER,'>>',"logfile_auto.log")||die "$!";		# global logfile

my$infile=$ARGV[0];
chomp $infile;

my$cu=`pwd`;

my$there=`ls $infile`;

if($there=~/$infile/){
  print "found file $infile in $cu, starting ...\n";
}
else{
  die  "did not find $infile in $cu\n";
}

my$copyfind_circ= system("cp $infile /media/daniel/NGS1/RNASeq/find_circ/auto_infile.txt");

my$copycircexone= system("cp $infile /media/daniel/NGS1/RNASeq/find_circ/circexplorer/CIRCexplorer/auto_infile.txt");

# now start both auto_automaker.pl with auto_infile.txt
chdir "/media/daniel/NGS1/RNASeq/find_circ/";
my$startfin_ci= system("perl auto_automaker.pl auto_infile.txt");

chdir "/media/daniel/NGS1/RNASeq/find_circ/circexplorer/CIRCexplorer/";
my$startcirex= system("perl auto_automaker.pl auto_infile.txt");
