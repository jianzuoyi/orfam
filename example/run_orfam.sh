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
    