#!/bin/bash -e

# Example orfam commands on a small datasets

# 1. blast
time ../../bin/orfam blast \
    -o test_2 \
    -e 1e-20 \
    -t 20 \
    -T temp2 \
    -v \
    -k \
    ../../data/mm3/Mus_musculus.mm3.fa \
   test_1_intact.fa

# 2. final intact
time ../../bin/orfam or \
    -R ../../data/mm3/Mus_musculus.mm3.fa \
    -r ../../data/ORs/O43749.fasta \
    -B ../../data/ORs/O43749.bed \
    -b test_2_best_hits.gff \
    -O ../../data/ORs/outgroup.fa \
    -S ../../bin/infer_NJ_protein.mao \
    -o test_2  \
    -t 6 \
    -T temp2 \
    -k \
    -v \
MARK

# 3. blast
time ../../bin/orfam blast \
    -o test_2_flank \
    -e 1e-20 \
    -t 20 \
    -T temp2 \
    -v \
    -k \
   test_2_best_hits_flank_1000.fa \
   test_2_intact.fa
