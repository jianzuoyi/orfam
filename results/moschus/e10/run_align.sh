#!/bin/bash

# 1. Align with tblastn
time ../../bin/orfam align \
    -q 608_intact.fa \
    -s ../../data/moschus/ls35.final.scaf.gapcloser.fa \
    -o 608.tblastn \
    -e 1e-20 \
    -t 60 \
    -T temp \
    -v \
    -k \
