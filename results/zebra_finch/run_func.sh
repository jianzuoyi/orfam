#!/bin/bash

time ../../bin/orfam func \
    -R /home/zuoyi/data/zebra_finch/Taeniopygia_guttata.taeGut3.2.4.dna.toplevel.fa \
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
