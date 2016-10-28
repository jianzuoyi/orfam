cat 608_intact.fa finalpseudo_nonsense.fa finalpseudo_frameshift.fa finalpseudo_others.fa > intact_pseudo.fa
fastalength -f intact_pseudo.fa | awk '{print $1"#"$2}' > length_intact_pseudo.txt
cat finaltruncated.gff| awk '{print ($5-$4+1)/3"#"$9}' > length_truncated.txt
cat length_intact_pseudo.txt length_truncated.txt | awk -F '#' '$1>99 && $1<450' > length_count.txt

rm intact_pseudo.fa length_intact_pseudo.txt length_truncated.txt

