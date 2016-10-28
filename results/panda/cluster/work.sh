fastafetch -f panda_intact.fa -i panda_intact.fa.idx -q $1 > $1.fa
fastafetch -f panda_intact.fa -i panda_intact.fa.idx -q $2 > $2.fa
stretcher -asequence $1.fa -bsequence $2.fa -outfile $1_$2.txt
cat $1_$2.txt | grep 'Identity'
cat $1_$2.txt | grep 'Similarity'

