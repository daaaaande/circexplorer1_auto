#/usr/bin/perl -w
use strict;

system("clear");

open(ER,'>>',"logfile_auto.log")||die "$!";		# global logfile

system("rm auto.bam.*.bam");# just deleting leftovers to be sure
system("rm tmp_*.bam");

my$inputfile=$ARGV[0];
chomp$inputfile;
open(IN,$inputfile)|| die "$!";	# infile is a .csv file steptwo output.csv
my@lines=<IN>;
my$error="";# collecting dump
my@groups=();
my$errortwo="";
foreach my $singleline (@lines){
	if($singleline =~ /[a-z]/g){
		chomp $singleline;
		my@lineparts=split(/\s+/,$singleline);
		my$fileone=$lineparts[0];
		my$filetwo=$lineparts[1];
		my$samplename=$lineparts[2];
		my$groupname=$lineparts[3];
		chomp $samplename;
		chomp $fileone;
		chomp $filetwo;
		print "finding circs in sample $samplename...\n";
		$error=system("perl circexplorer1_starter_1.pl $fileone $filetwo $samplename");
		my$err2=system("perl circexplorer1_out_reader.pl run_$samplename/CIRCexplorer_circ.txt run_$samplename/$samplename.processed.tsv $samplename");
		# will dump file into run_$samplename/$samplename_processed.tsv, this to be done for every file
		print ER "errors:\n$error\n$err2\n";
		if($groupname=~/[a-z]/gi){
			if(!(grep(/$groupname/,@groups))){ # check if group already present
				mkdir $groupname;		# IF NOT, MAKE GROUPDIR
				push(@groups,$groupname);
			}
		$errortwo=system ("cp run_$samplename/$samplename.processed.tsv $groupname/");
		}

		print ER "errors auto_moving:\n$errortwo\n";
	}


}

foreach my $groupname (@groups){
	my$errseding=system("sed -i '1d' $groupname/*.tsv"); # will remove first line from steptwo output i.e headers
	my$errcat=system("cat $groupname/*.tsv >$groupname/allsites_bedgroup_$groupname.csv");
	my$errmatxrix=system("perl matrixmaker.pl $groupname/allsites_bedgroup_$groupname.csv $groupname/allcircs_matrixout.txt");
	my$matrtmaker=system("perl matrixtwo.pl $groupname/allcircs_matrixout.txt $groupname/allc_matrixtwo.tsv");
	print ER "errors catting $groupname .csv files together:\n$errcat\n";
	print ER "errors making matrix for $groupname/allsites_bedgroup_$groupname.csv :\n$errmatxrix\n";
	print ER "errors making second matrix for $groupname/allsites_bedgroup_$groupname.csv :\n$matrtmaker\n";

}

print ER "finished with all groups\n";
