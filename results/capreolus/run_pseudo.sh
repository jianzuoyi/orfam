#!/bin/bash

time orfam pseudo \
    -s ../../data/capreolus/GCA_000751575.1_kmer631_genomic.fna \
    -q intact/608_intact.fa \
    -b 608_best_hit.gff \
    -i 608_intact.fa \
    -o final \
    -T temp \
    -k \
    -v
