#!/bin/bash

# 1. Align with tblastn
time ../../bin/orfam align \
    -q 608_intact.fa \
    -s ../../data/alpaca/vicPac2.fa \
    -o 608.tblastn \
    -e 1e-20 \
    -t 20 \
    -T temp \
    -v \
    -k \
