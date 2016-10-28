#!/bin/bash

time ../../bin/orfam func \
    -R ../../data/mm3/Mus_musculus.mm3.fa \
    -r ../../data/ORs/O43749.fasta \
    -B ../../data/ORs/O43749.bed \
    -O ../../data/ORs/outgroup.fa \
    -S ../../bin/infer_NJ_protein.mao \
    -A reviewed.tblastn \
    -o reviewed \
    -t 20 \
    -T temp \
    -k \
    -v 
