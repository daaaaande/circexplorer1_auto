#/usr/bin/perl -w
use strict;

system("clear");

open(ER,'>>',"logfile_auto.log")||die "$!";		# global logfile
my $start = time;

my$linfile= $ARGV[0];
chomp $linfile;
print "reading input file $linfile ...\n";
# output file second argument adding coordinates
open(IN,$linfile)|| die "$!";
my@allelines= <IN>;
foreach my $longline ($allelines){
  my@lineparts=split(/\t/,$longline);
  



}
