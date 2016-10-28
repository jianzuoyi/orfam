# fastaexplode -f 608_intact.fa -d ORs_1
# fastaexplode -f 608_intact.fa -d ORs_2
rm -i identity.txt
for OR1 in $(find ./ORs_1 -name '*.fa'); do
    for OR2 in $(find ./ORs_2 -name '*.fa'); do
	stretcher -asequence $OR1 -bsequence $OR2 -outfile /dev/stdout | grep 'Identity' | cut -f 2 -d '(' | cut -f 1 -d '%' >> identity.txt
    done
done

#cat identity.txt| sort -n | uniq | head
#cat identity.txt| sort -n | uniq | tail

