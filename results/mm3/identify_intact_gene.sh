#!/bin/bash -e

# Example orfam commands on a small datasets

# 1. Align with tblastn
time ../../bin/orfam align \
    -q query_one.fa \
    -s Mus_musculus_mm3_flank_5000.fa \
    -o tblastn_tab_ors2flank5000 \
    -e 1e-10 \
    -t 20 \
    -T temp \
    -v \
    -k \
exit 1
# 2. Identify intact genes
