
######################
### Initialization ###

db.fullname="alu.n : alu repeat element. alu.a : translation of alu.n repeats"
db.name=alu
db.type=nucleic_protein

#data.dir=/bank/test
offline.dir.name=biomaj/ncbi/blast/alu_tmp
dir.version=ncbi/blast/alu

frequency.update=0

### Pre Process ###

db.pre.process=PRE1

PRE1=premail

premail.name=sendMail
premail.exe=sendMailTLSE.pl
premail.args=-s '[NCBI Blast - db.name] Start Biomaj session' -m 'local.time'
premail.desc=mail
premail.type=info

### Synchronization ###

files.num.threads=1

# NCBI (download fasta)
protocol=ftp
server=ftp.ncbi.nih.gov
remote.dir=/blast/db/FASTA/

release.file=
release.regexp=
release.file.compressed=

remote.files=^alu.*\\.gz$

#Uncomment if you don't want to extract the data files.
#no.extract=true

local.files=^alu\\.(a|n).*

### Post Process ###  The files should be located in the projectfiles/process directory.

db.post.process=POST1

POST1=formatdb,postmail

formatdb.name=formatdbTLSE
formatdb.exe=formatdbTLSE.pl
formatdb.args=--fasta 'alu.a.* alu.n.*'
formatdb.desc=Index blast
formatdb.type=index
#--------
postmail.name=sendMail
postmail.exe=sendMailTLSE.pl
postmail.args=-s '[NCBI Blast - db.name remote.release] End Post Process formatdb' -m 'local.time'
postmail.desc=mail
postmail.type=info

### Deployment ###

keep.old.version=1
