# circexplorer1_auto
## automating circexplorer 1 using STAR aligner
the output ought to be in the same format than auto_find_circ, so some changes:
- in the output matrices the circexploere score is shown twice, and means something different than in find_circ_auto
- circexplorer would be able to attach genes to coordinates in the outputfile, but is now added later with the first matrix that is created



# two main levels of automation:
1. manually circexplorer1_starter_1.pl with inputfile1 inputfile2 samplename ; then circexplorer1_out_reader.pl with its outfile, then optional matrixmaker/matrixtwo.pl
2. auto_automaker:
##  start auto_automaker.pl with inputfile1 inputfile2 samplename groupname table, separated by \t
```bash
~ head infiles_for_auto_automaker.txt   
lineonefile1 linetwofile1 samplename1 group1   
lineonefile2  linetwofile2  samplename2 group1
```    
the group will lead to auto_automaker making a directory named after the group where all the resulting .csv files will be copied into, catted into one big .csv file and then run matrixmaker.pl with this as an input and then start matrixtwo.pl with this as an input

3. let find_circ/godfather.pl handle it all, see find_circ/godfather.pl

## before starting these scripts you will need:
- paired end RNA-seq files (sample1_line1.fastq and sample1_line2.fastq)
- get those file for RNAse treated cells from the same sample aswell
- install STAR aligner
- build STAR index with hg19.fa and ensembl annotations
- get filenames into the same dir, get a samplefile with files, samplename and group like find_circ_auto needs
- protip: get a different name for each sample! (that means unique ones!)- that always needs at least one letter in its name! (697 and 697_r are not well suited, b697 and a697_r are!)



# compared to find_circ_auto:
 the scripts that handle the commands until the outputfiles are readable for the matrixmaker are of course different, the upper automation layers are close to the find_circ_auto repo with minor differences:
 - the group/processsed.tsv instead of .csv: the files ate tab separated anyway, so using the corresponding .tsv here
