#!/bin/csh -e

if (-e embl.mn) then
\rm embl.mn
endif
echo ">>>Starting script check_acnuc_embl.csh"
setenv workdir  $BIOMAJ_ROOT/$1
setenv workdir  $1
setenv acnuc $workdir/index
setenv gcgacnuc $workdir/flat_files
query << eof
sel
n=@
save

embl.mn
stop
eof
set buf = `wc embl.mn`
set ns = $buf[1]
echo "There is $ns sequences in the database"
echo "<<< End of script check_acnuc_embl.csh"
echo
