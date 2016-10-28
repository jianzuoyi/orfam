cat 608_intact.fa finalpseudo_nonsense.fa finalpseudo_frameshift.fa finalpseudo_others.fa| grep '>' | cut -f 2 -d '>' | cut -f 1 -d ':' > scaffold_intact_pseudo.txt
cat finaltruncated.gff | cut -f 1 > scaffold_truncated.txt
cat scaffold_intact_pseudo.txt scaffold_truncated.txt | sort | uniq -c | awk '{print $1";"$2}' > scaffold_genes.txt

rm scaffold_intact_pseudo.txt scaffold_truncated.txt
