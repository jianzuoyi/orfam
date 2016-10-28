#!/bin/bash

# 1. Align with tblastn
time ../../bin/orfam align \
    -q one.fa \
    -s ../../data/mm3/Mus_musculus.mm3.fa \
    -e 1e-10 \
    -t 20 \
    -T temp \
    -v \
    -k \
