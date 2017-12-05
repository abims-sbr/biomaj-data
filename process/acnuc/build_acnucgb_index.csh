#!/bin/csh -e
# Construit une base nucleique au format GenBank
# =========================================

if ($1 == "HELP") then 

echo
echo " Build a nucleic database (gb)"
echo " ============================="
echo " Usage  : build_acnucgb_index.csh directory"
exit(1)
endif

setenv workdir  $BIOMAJ_ROOT/$1
setenv workdir  $1
setenv rep $workdir
setenv ffiles $rep/flat
setenv acnuc $rep/index
setenv gcgacnuc $rep/flat_files
setenv miscdir /banques/biomaj/utils/
setenv bufname refseq
set taxurl=ftp://ftp.ncbi.nih.gov/pub/taxonomy/taxdump.tar.gz
setenv taxman $workdir/taxman

# test
echo
echo ">>> Debut du script build_acnuc_index.csh"
echo "acnuc variable is set to     $acnuc"
echo "gcgacnuc variable is set to  $gcgacnuc"


# telechargement de la version
cd $workdir
wget --glob=on ftp://ftp.ncbi.nih.gov/refseq/release/release-notes/RefSeq-release\*.txt
set numrel = `head -8 RefSeq-release*.txt|grep Release`
set daterel = `head -7 RefSeq-release*.txt | tail -1`
set stats = `grep RNA: RefSeq-release*.txt`

# telechargement de la taxonomy
cd $workdir
if (-d taxman) then
\rm -r taxman
endif
mkdir taxman
cd taxman
echo Downloading taxonomy ....
echo -------------------------
echo wget  -N -nv $taxurl
wget  -N -nv $taxurl
gzip -d  taxdump.tar.gz
tar xvf taxdump.tar
echo "Contents:"
echo "---------" 
ls
#exit(1)
# preparation des directory


foreach dir ($acnuc $gcgacnuc)
 if (-d $dir) then
 \rm -r $dir
 mkdir $dir
 endif
end


foreach dir ($acnuc $gcgacnuc)
 if (! -d $dir) then
 echo " The directory $dir does not  exists."
 mkdir $dir
 endif
end




# Initialise
echo
echo ===============
echo Initialisation
echo ---------------
echo run initf
cd $acnuc
if ( ! -e custom_qualifier_policy) then
cp $miscdir/custom_qualifier_policy .
endif
if ( ! -e custom_qualifier_policy) then
echo
echo "****ATTENTION**** pas de fichier custom_qualifier_policy."
echo "Une copie doit se trouver dans $miscdir"
echo
exit(1)
endif
echo initf genbank  acc=20 hsub=2000003 hkwsp=1000003
initf genbank standardextonly acc=20 hsub=2000003 hkwsp=1000003
# Ajout des codes supplementaires
# ================================

echo
echo ====================
echo Addition of new codes
echo ---------------------
 
smjytload << eof
4
A
3'INT
.3I 3'intron
3'NCR
.3F  3'-non coding region
5'INT
.5I 5'intron
5'NCR
.5F  5'-non coding region
INT_INT
.IN  internal intron    

8
eof

                                    

# Index
echo
echo ================
echo Index generation 
echo ----------------


cd $ffiles
echo ou suis je
pwd
ls
set ffs = `ls *.gbff`



cd $gcgacnuc

set nb = 1
foreach f ($ffs)
echo ln -s ../flat/$f $bufname.$nb.seq
ln -s ../flat/$f $bufname.$nb.seq
@ nb = $nb + 1
end

set nbfile = $nb
@ nb = 1
echo "acnucgener logs "> $workdir/acnucgener.log
while ($nb < $nbfile)


echo Generate  partition $bufname.$nb
echo --------------------
echo acnucgener d $bufname.$nb -mmap kshrt -mmap ksub -mmap klng -mmap kkey -mmap kspec
acnucgener d $bufname.$nb -mmap kshrt -mmap ksub -mmap klng -mmap kkey -mmap kspec >> $workdir/acnucgener.log
echo "Generation ok "
echo ""
@ nb = $nb + 1 
end
echo
echo ================
echo Include taxonomy
echo ----------------

readncbitaxo -niveau	>> $workdir/acnucgener.log
echo chargement taxonomie terminee 


echo
echo ==================
echo run setcodegenbank
echo ------------------
setcodegenbank.com	>> $workdir/acnucgener.log

echo
echo "====================================="
echo Suppression journaux et annees inutiles
suppr_unused smj $workdir/acnucgener.log

echo 
echo =========================
echo Deletion of unused fields
echo -------------------------
suppr_unused bib >> $workdir/acnucgener.log
suppr_unused aut >> $workdir/acnucgener.log
suppr_unused acc >> $workdir/acnucgener.log
suppr_unused spec>> $workdir/acnucgener.log
suppr_unused key >> $workdir/acnucgener.log

echo
echo ============
echo run ordnet S 
echo ------------
ordnet<<! >> $workdir/acnucgener.log
S
!

echo
echo ============
echo run ordnet K
echo ------------
ordnet<<! >>& $workdir/acnucgener.log
K
!

echo 
echo ================
echo run newordalphab
echo ----------------
newordalphab >>& $workdir/acnucgener.log

if (-e SUBDESCR) then
 \rm -r SUBDESCR
endif
echo 

cd $acnuc
#cp $miscdir/refseq/HELP* .
echo "INTRODUCTION     (2eme ligne doit contenir le nom de la banque)" > HELP_TMP
echo "             ****     ACNUC Data Base Content      ****        " >> HELP_TMP    
echo "  RNA sequences - $numrel ($daterel) Last Updated: Jan  1, 3000" >> HELP_TMP
echo "0 bases; 0 sequences; 0 subseqs; 0 refers."                      >> HELP_TMP
echo "                NCBI Reference Sequence (RefSeq) Database"       >> HELP_TMP           
cat HELP_TMP $miscdir/refseq/HELP_WIN > HELP_WIN

echo "CONT Nber of lines= 5    "            > HELP_TMP                                         
echo "             ****     ACNUC Data Base Content      ****    "                >> HELP_TMP                      
echo "  RNA sequences - $numrel ($daterel) Last Updated: Jan  1, 3000"            >> HELP_TMP    
echo "0 bases; 0 sequences; 0 subseqs; 0 refers."                                 >> HELP_TMP 
echo "                NCBI Reference Sequence (RefSeq) Database"                  >> HELP_TMP    
cat HELP_TMP $miscdir/refseq/HELP > HELP

echo
echo "====================================="
echo run updatehelp
updatehelp

echo "Statistics from RefSeq"
echo  $stats
echo "Statistics from ACNUC"
grep  refers HELP


echo "<<< End of script build_acnucgb_index.csh"
echo
