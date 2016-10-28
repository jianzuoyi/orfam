#!/bin/bash

# 1. Align with tblastn
time ../../bin/orfam align \
    -q 608_intact.fa \
    -s /home/zuoyi/data/microbat/microbat.fa \
    -o final \
    -e 1e-20 \
    -t 20 \
    -T temp \
    -v \
    -k \
