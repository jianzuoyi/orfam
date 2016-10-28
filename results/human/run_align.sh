#!/bin/bash

# 1. Align with tblastn
time ../../bin/orfam align \
    -q ../../data/ORs/608.fa \
    -s ../../data/hg38/hg38.fa \
    -o 608_e20.tblastn \
    -e 1e-20 \
    -t 60 \
    -T temp \
    -v \
    -k \
