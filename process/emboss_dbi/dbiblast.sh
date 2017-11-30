#!/bin/bash

# Args:
# seqtype: N (nucleic), P (proteic), ? unknown
# subdirectory: blast
# subdirectory destination: XXX -> emboss_XXX

mkdir $datadir/$dirversion/future_release/emboss_$3

curdate=$(date +"%d/%m/%y")
echo "dbiblast -blastversion 2 -dbname $dbname -seqtype $1 -filenames '*.*' -release current -date $curdate -directory $datadir/$dirversion/future_release/$2 -indexoutdir $datadir/$dirversion/future_release/emboss_$3 -outfile outfile.dbiblast"
dbiblast -blastversion 2 -dbname $dbname -seqtype $1 -filenames '*.*' -release current -date $curdate -directory $datadir/$dirversion/future_release/$2 -indexoutdir $datadir/$dirversion/future_release/emboss_$3 -outfile outfile.dbiblast
