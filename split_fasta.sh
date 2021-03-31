#!/bin/bash

## run like: bash thisscript.sh myfasta.fa

fa=$1

## if using conda
conda activate omniCLIP3 

seqkit split --by-id $fa

exit 0
