#!/bin/bash

## fix chromosome names in gencode fasta to only contain chrN and not spaces and stuff after
## run on already gzipped split fasta files

for file in *.fa.gz; do zcat $file |  sed 's/\s.*$//' > ${file%.gz}; done

