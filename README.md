# circexplorer1_auto
## automating circexplorer 1 using STAR aligner
the output ought to be in the same format than auto_find_circ, so some changes:
- in the output matrices the circexploere score is shown twice, and means something different than in find_circ_auto
- circexplorer would be able to attach genes to coordinates in the outputfile, but is now added later with the first matrix that is created


#### the godfather.pl script is there to start find_circ and circexplorer1 with the same samplesheet and files at the same time, but not fully done yet!

## before starting these scripts you will need:
- paired end RNA-seq files (sample1_line1.fastq and sample1_line2.fastq)
- get those file for RNAse treated cells from the same sample aswell
- install STAR aligner
- build STAR index with hg19.fa and ensembl annotations
- get filenames into the same dir, get a samplefile with files, samplename and group like find_circ_auto needs


# compared to find_circ_auto:
 the scripts that handle the commands until the outputfiles are readable for the matrixmaker are of course different, the upper automation layers are close to the find_circ_auto repo with minor differences:
 - the group/processsed.tsv instead of .csv: the files ate tab separated anyway, so using the corresponding .tsv here
