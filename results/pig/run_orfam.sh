#!/bin/bash -e

# Example orfam commands on a small datasets

# 1. align with tblastn
time ../../bin/orfam blast \
    -o OR2mm10 \
    -t 20 \
    -T temp \
    -v \
    -k \
    ../../data/mm10/mm10.fa \
    ../../data/ORs/Mus_musculus_ORs.fa

# 2. orf
time ../../bin/orfam or \
    -R ../../data/mm10/mm10.fa \
    -r ../../data/ORs/O43749.fasta \
    -B ../../data/ORs/O43749.bed \
    -A OR2mm10.txt \
    -O ../../data/ORs/outgroup.fa \
    -S ../../bin/infer_NJ_protein.mao \
    -o ORs \
    -t 6 \
    -T temp \
    -k \
    -v \
