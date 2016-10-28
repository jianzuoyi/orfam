#!/bin/bash

# 1. Align with tblastn
time ../../bin/orfam align \
    -q intact/608_intact.fa \
    -s ../../data/polar_ursus/Ursus_maritimus.scaf.fa \
    -o 608.tblastn \
    -e 1e-20 \
    -t 20 \
    -T temp \
    -v \
    -k \
