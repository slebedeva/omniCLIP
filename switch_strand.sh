#!/bin/bash

## switch strand of RNA-seq to be able to use as input with omniCLIP
mybam=$1

## run like thisscript.sh bam

samtools view -H $mybam > $mybam.header &&
samtools view $mybam > $mybam.sam &&
./switch_strand.awk $mybam.sam > $mybam.inv &&
cat $mybam.header $mybam.inv | samtools view -b > $mybam.plus &&
rm $mybam.header $mybam.sam $mybam.inv &&
exit 0
