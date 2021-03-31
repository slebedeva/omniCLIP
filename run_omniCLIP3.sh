#!/bin/bash

### !!! Attention: there is a bug I could not fix that at some point it uses all available CPUs. So if running on HPC cluster need 32 cores!!!


########## !!! change these values every time: #############
## 1. data dir (where your bam files for CLIP are)
mydir="."

## 2. sample name
myname="test"

## 3. where to output 
outdir="${mydir}/${myname}"
tmpdir="${outdir}/tmp"
mkdir -p $tmpdir

## 4. database to use 
### how to create db see make_omniiCLIP3_database.sh script, you can use gff3 from gencode like this #python data_parsing/CreateGeneAnnotDB.py INPUT.gff OUTPUT.gff.db

myGenome="" ##path to your genome, needs to be gzipped and one fasta file per chromosome
myAnno="" ##database created with above script

## 5. Background bam files ## change accordingly: RNAseq as background samples (use input as another fake CLIP and substract these peaks as false positives)
inputdir="" ## path to directory with replicates of RNAseq
## this will make input argument for RNAseq provided the directory contains only bam files for this sample
## classically, RNAseq is on the opposite strand from CLIP! reverse strand with small script (the file will be *.bam.plus)
backgr=""
for file in $( ls ${inputdir}/*.bam.plus ); do
    backgr=$(echo "$backgr --bg-files $file")
done


## 6. Actual CLIP bam files 
### construct input argument for CLIP bam files
clipinput=""
for file in $( ls ${mydir}/*.bam ); do clipinput=$(echo "$clipinput --clip-files $file"); done

## some summary info for log
echo "$(date) processing ${myname} from ${mydir}... CLIP is ${clipinput}, background is ${backgr}, output is in ${outdir}"

## activate conda environment, skip this if you do not use it
conda activate omniCLIP3
export PYTHONNOUSERSITE=True

eval "python omniCLIP.py $clipinput --annot  $myAnno --genome-dir $myGenome --save-tmp $backgr --out-dir $outdir --tmp-dir $tmpdir  --fg_pen 5 --filter-snps --max-it 10 --bck-var --nb-cores 1 --nr_mix_comp 5 --diag_event_mod DirchMultK --diag-bg --norm_class --bg-type Coverage_bck --mask-miRNA --rev_strand 0 --seed 42 --verbosity 2"
## if restarting failed run, add #--use-precomp-CLIP-data --use-precomp-bg-data --restart-from-iter
## params from Philipp were  --nr_mix_comp 10 and no --max-mismatch (default is 2) and no seed and pv
## can change --fg_pen from 0 to 50 or more (increasing it will get you less clusters and will split long clusters into shorter ones)

exit 0
