#!/bin/bash

# 1. Align with tblastn
time ../../bin/orfam align \
    -q ../../data/ORs/ors_reviewed_removed.fa \
    -s ../../data/mm10/mm10.fa \
    -o 645 \
    -e 1e-10 \
    -t 20 \
    -T temp \
    -v \
    -k \
