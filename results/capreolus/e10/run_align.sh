#!/bin/bash

# 1. Align with tblastn
time ../../bin/orfam align \
    -q ../../data/ORs/608.fa \
    -s ../../data/capreolus/GCA_000751575.1_kmer631_genomic.fna \
    -o 608.tblastn \
    -e 1e-10 \
    -t 40 \
    -T temp \
    -v \
    -k \
