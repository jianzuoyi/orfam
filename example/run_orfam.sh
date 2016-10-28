# Example orfam commands on a small datasets

# 1. align with tblastn
../bin/orfam blast \
	     -o example \
	     data/ref.fa \
	     data/or.fa

# 2. identify ORs
../bin/orfam or \
	     -o example \
	     example.gff
