#/usr/bin/perl -w
use strict;

system("clear");

open(ER,'>>',"/home/daniel/logfile_auto.log")||die "$!";		# global logfile

chdir "/media/daniel/NGS1/RNASeq/find_circ/circexplorer/CIRCexplorer/";

#######################################################
# usage: get samples.csv into circexplorer1_auto
#					 go to CIRCEXPLORER//circexplorer1_auto
#						perl auto_automaker.pl samples.csv
#######################################################
#auto_automaker.pl for circexplorer1_auto
# 		- needs a inputfile as specified in the README.md
#			- will start circexplorer1_starter_1 for every sample
#			- can in return be started by the godfather.pl script, this will handle the infile location correctly
#			- makes a group into a dir of the parent dir where the bed.csv files for each group will be collected
#			- then makes the two matrices for each group in the groupfolders
#			- also makes one dir run_startdate in the parent dir where data from all samples will be made into two big matrices
###############################################


my$inputfile=$ARGV[0];


my$date= localtime();
$date=~s/\s+/_/g;
$date=~s/[0-9]//g;
$date=~s/\://g;
$date=~s/\_\_//g;
mkdir "all_run_$date";



chomp$inputfile;
open(IN,$inputfile)|| die "$!";	# infile is a .csv file steptwo output.csv
my@lines=<IN>;
my$error="";# collecting dump
my@groups=();
my$errortwo="";
foreach my $singleline (@lines){
	if($singleline =~ /[A-z]/gi){
		chomp $singleline;
		my@lineparts=split(/\s+/,$singleline);
		my$fileone=$lineparts[0];
		my$filetwo=$lineparts[1];
		my$samplename=$lineparts[2];
		my$groupname=$lineparts[3];
		chomp $samplename;
		chomp $fileone;
		chomp $filetwo;
		my$tim=localtime();
	print ER "##############################################################\n";
	print ER "starting @ $tim \nfinding circs in sample $samplename with circexplorer1...\n";

		$error=system("perl circexplorer1_auto/circexplorer1_starter_1.pl $fileone $filetwo $samplename");
		my$err2=system("perl circexplorer1_auto/circexplorer1_out_reader.pl run_$samplename/CIRCexplorer_circ.txt run_$samplename/$samplename.processed.tsv $samplename");
		# will dump file into run_$samplename/$samplename_processed.tsv, this to be done for every file
	#	my$erdel=system("rm $fileone $filetwo");

		print ER "errors executing circexplorer1:\n$error\nerrors executing circex1circexplorer1_out_reader:\n$err2\nerrors deleting files:\nerdel\n";
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
	my$errmatxrix=system("perl circexplorer1_auto/matrixmaker.pl $groupname/allsites_bedgroup_$groupname.csv $groupname/allcircs_matrixout.txt");
	my$matrtmaker=system("perl circexplorer1_auto/matrixtwo.pl $groupname/allcircs_matrixout.txt $groupname/allc_matrixtwo.tsv");
	print ER "errors catting $groupname .csv files together:\n$errcat\n";
	system("cp $groupname/allsites_bedgroup_$groupname.csv all_run_$date/");
	print ER "errors making matrix for $groupname/allsites_bedgroup_$groupname.csv :\n$errmatxrix\n";
	print ER "errors making second matrix for $groupname/allsites_bedgroup_$groupname.csv :\n$matrtmaker\n";

}
#
my$erralcat=system("cat all_run_$date/* >all_run_$date/all_run_$date.allbeds.circex1.out");
my$erralm1=system("perl circexplorer1_auto/matrixmaker.pl all_run_$date/all_run_$date.allbeds.circex1.out all_run_$date/allsamples_matrix.circex1.tsv");
my$err_mat2=system("perl circexplorer1_auto/matrixtwo.pl all_run_$date/allsamples_matrix.circex1.tsv all_run_$date/allsamples_m_heatmap.circex1.tsv");

print "error making files in all_run_$date :\ncat:\t$erralcat\nmatrix 1 creation:\t$erralm1 \nmatrix 2 creation:\n$err_mat2\n";

# now copy two matrix files into find_circ dir
my$errtransfer=system("cp all_run_$date/*.tsv /media/daniel/NGS1/RNASeq/find_circ/all_run_$date/");
print ER "transfering matrix to find_circ dir errors: \n$errtransfer\n";


print ER "finished with all groups\n";
