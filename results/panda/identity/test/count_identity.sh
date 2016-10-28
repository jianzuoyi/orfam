#for OR1 in $(ls ORs_1); do
for OR1 in $(find ./ORs_1 -name '*.fa'); do
    for OR2 in $(find ./ORs_2 -name '*.fa'); do
	stretcher -asequence $OR1 -bsequence $OR2 -outfile /dev/stdout | grep 'Identity'
    done
done

#stretcher -asequence -bsequence -outfile

#find ./ORs_1 -name '*.fa' | xargs -n 1 -i stretcher -asequence {} -bsequence 608_intact.fa -outfile /dev/stdout