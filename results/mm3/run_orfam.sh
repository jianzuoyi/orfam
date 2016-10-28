#!/bin/bash -e

# Example orfam commands on a small datasets

# 1. Align with tblastn
time ../../bin/orfam align \
    -q query_one.fa \
    -s ../../data/mm3/Mus_musculus.mm3.fa \
    -o tblastn_tab_ors2mm3 \
    -e 1e-10 \
    -t 20 \
    -T temp \
    -v \
    -k \

# 2. Identify functional olfactory receptors
time ../../bin/orfam func \
    -R ../../data/mm3/Mus_musculus.mm3.fa \
    -r ../../data/ORs/O43749.fasta \
    -B ../../data/ORs/O43749.bed \
    -O ../../data/ORs/outgroup.fa \
    -S ../../bin/infer_NJ_protein.mao \
    -A tblastn_tab_ors2mm3.txt \
    -o or  \
    -t 20 \
    -T temp \
    -k \
    -v
