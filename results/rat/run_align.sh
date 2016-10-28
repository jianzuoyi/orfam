#!/bin/bash

# 1. Align with tblastn
time ../../bin/orfam align \
    -q ../../data/ORs/ORs_filtered.fa \
    -s ../../data/rat/rn6.fa \
    -o 608.tblastn \
    -e 1e-10 \
    -t 20 \
    -T temp \
    -v \
    -k \
