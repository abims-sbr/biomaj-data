#!/bin/bash

# Args:
# idformat: embl
# subdirectory origin: fasta
# subdirectory destination: XXX -> emboss_XXX

mkdir $datadir/$dirversion/future_release/emboss_$3

curdate=$(date +"%d/%m/%y")
echo "dbigcg -dbname $dbname -idformat $1 -filenames '*.*' -release current -date $curdate -directory $datadir/$dirversion/future_release/$2 -indexoutdir $datadir/$dirversion/future_release/emboss_$3 -outfile outfile.dbigcg"
dbigcg -dbname $dbname -idformat $1 -filenames '*.*' -release current -date $curdate -directory $datadir/$dirversion/future_release/$2 -indexoutdir $datadir/$dirversion/future_release/emboss_$3 -outfile outfile.dbigcg
