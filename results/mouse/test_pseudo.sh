#!/bin/bash

time orfam pseudo \
    -s ../../data/mm10/mm10.fa \
    -q ../../data/ORs/ors_reviewed_removed.fa \
    -b 645_best_hit.gff \
    -i 645__intact.fa \
    -o 645 \
    -T temp \
    -k \
    -v
