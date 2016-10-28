#!/bin/bash

time ../../bin/orfam func \
    -R /home/zuoyi/data/gallus/G.gallus.dna.fa \
    -r ../../data/ORs/O43749.fasta \
    -B ../../data/ORs/O43749.bed \
    -O ../../data/ORs/outgroup.fa \
    -S ../../bin/infer_NJ_protein.mao \
    -A 608.tblastn \
    -o 608 \
    -t 20 \
    -T temp \
    -k \
    -v 
