#/usr/bin/perl -w
use strict;

# starting vars
my$currdir=`pwd`;
my$starttime= time;

open(ER,">>", "auto_log.log")|| die "$!";

system("rm Chimeric.out.junction");
system("rm fusion_junction.txt");

# first get reference place for hg19
my$bowtwiindexplace="/media/daniel/NGS1/RNASeq/find_circ/circexplorer/CIRCexplorer/";

# change to reference place for execution
if(!($currdir eq $bowtwiindexplace)){
chdir $bowtwiindexplace;
}

# two read lanes, one sample name for first layer of automation
my$infile1=$ARGV[0];
chomp $infile1;
my$infile2=$ARGV[1];
chomp $infile2;
my$samplename=$ARGV[2];
chomp $samplename;
# if dir changes during chdir, then append old dir onto filename to preserve path
my$fullfileone="$infile1";
my$fullfiletwo="$infile2";

#### start of circexplorer1
mkdir "run_$samplename";
# make dir, move files there, one dir per sample per group

# about 30 min in single core
my$tophatout=system("STAR --chimSegmentMin 10 --runThreadN 10 --genomeDir . --readFilesIn $fullfileone $fullfiletwo");
# creates auto_$samplename dir in test/
print ER "errors during STAR alignment:\n $tophatout\n";


my$btofq= system("star_parse.py Chimeric.out.junction fusion_junction.txt");
print ER "errors converting:\n $btofq\n";
system("mv Chimeric.out.junction run_$samplename/");

my$tophattwoout=system("CIRCexplorer.py -j fusion_junction.txt -g hg19.fa -r hg19_ref.txt");
# now move all files into dir?
system("mv CIRCexplorer_circ.txt run_$samplename/");

my$fulltime=((time - $starttime)/60);

print ER "errors running circexplorer1:\n$tophattwoout\n";
print ER "done processing $samplename in $fulltime minutes \n";
