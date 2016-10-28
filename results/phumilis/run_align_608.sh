#!/bin/bash

# 1. Align with tblastn
time ../../bin/orfam align \
    -q ../../data/ORs/ORs_filtered.fa \
    -s /home/zuoyi/data/phumilis/Phumilis.scafSeq.fill.GapCloser \
    -o 608 \
    -e 1e-10 \
    -t 20 \
    -T temp \
    -v \
    -k \
