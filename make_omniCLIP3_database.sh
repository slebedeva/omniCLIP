#!/bin/bash

# if using conda
conda activate omniCLIP3
export PYTHONNOUSERSITE=True

mygff="" ## put your gff3 file here (e.g. gencode gff3)

### create db (will be written where the gff3 file is)
python data_parsing/CreateGeneAnnotDB.py $mygff ${mygff}.db

exit 0
