<<<<<<< HEAD
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
=======
# 1. Align with tblastn
orfam align \
    -q data/known_ORs.fa \
    -s data/human_g1k_v37_20_42220611-42542245.fasta \
    -o human \
    -e 1e-20 \
    -t 20 \
    -T temp \
    -v \
    -k

# 2. identify intact OR genes
orfam func \
    -R data/human_g1k_v37_20_42220611-42542245.fasta \
    -r data/O43749.fasta \
    -B data/O43749.bed \
    -O data/outgroup.fa \
    -S ../bin/infer_NJ_protein.mao \
    -A human.tblastn \
    -o human \
    -t 20 \
    -T temp \
    -k \
    -v

# 3. identify truncated OR genes and OR pseudogenes
orfam pseudo \
    -s data/human_g1k_v37_20_42220611-42542245.fasta \
    -q human_intact.fa \
    -b human_best_hit.gff \
    -i human_intact.fa \
    -o human \
    -T temp \
    -k \
    -v
    
>>>>>>> 3bc44e08e2a4974d74a696fb1e07bea84b08d77b
