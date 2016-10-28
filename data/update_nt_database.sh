# update ncbi nt database


for n in 28 29 30 31 32 33
do
    wget ftp://ftp.ncbi.nlm.nih.gov/blast/db/nt.$n.tar.gz.md5
    wget ftp://ftp.ncbi.nlm.nih.gov/blast/db/nt.$n.tar.gz
done
