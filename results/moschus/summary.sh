echo best-hit $(cat 608_best_hit.gff| awk '{print ($5-$4+1)/3}' | sort -n | awk '$1>100'| wc -l) | tee best-hit.tmp
echo intact $(cat 608_intact.fa| grep '>' -c) | tee intact.tmp
echo truncted $(cat finaltruncated.gff| awk '{print ($5-$4+1)/3}' | awk '$1>100&&$1<450'| wc -l) | tee truncted.tmp
echo pseudo $(paste intact.tmp truncted.tmp | paste best-hit.tmp - | awk '{print $2-$4-$6}')

echo nonsense $(fastalength finalpseudo_nonsense.fa| cut -f 1 -d ' '  | awk '$1>100&&$1<450' | wc -l)
echo frameshift $(fastalength finalpseudo_frameshift.fa| cut -f 1 -d ' '  | awk '$1>100&&$1<450' | wc -l)
echo others $(fastalength finalpseudo_others.fa| cut -f 1 -d ' '  | awk '$1>100&&$1<450' | wc -l)

rm *.tmp