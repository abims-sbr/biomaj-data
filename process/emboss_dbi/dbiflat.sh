#!/bin/bash

# Args:
# idformat: swiss
# subdirectory origin: swissprot
# subdirectory destination: XXX -> emboss_XXX

mkdir $datadir/$dirversion/future_release/emboss_$3

curdate=$(date +"%d/%m/%y")
echo "dbiflat -dbname $dbname -idformat $1 -filenames '*.*' -release current -date $curdate -directory $datadir/$dirversion/future_release/$2 -indexoutdir $datadir/$dirversion/future_release/emboss_$3 -outfile outfile.dbiflat"
dbiflat -dbname $dbname -idformat $1 -filenames '*.*' -release current -date $curdate -directory $datadir/$dirversion/future_release/$2 -indexoutdir $datadir/$dirversion/future_release/emboss_$3 -outfile outfile.dbiflat
