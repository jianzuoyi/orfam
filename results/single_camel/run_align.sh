#!/bin/bash

# 1. Align with tblastn
time ../../bin/orfam align \
    -q ../../data/ORs/608.fa \
    -s /home/zuoyi/data/single_camel/single_camel.fa \
    -o 608.tblastn \
    -e 1e-10 \
    -t 20 \
    -T temp \
    -v \
    -k \
