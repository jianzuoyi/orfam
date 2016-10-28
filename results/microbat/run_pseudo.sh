#!/bin/bash

time orfam pseudo \
    -s /home/zuoyi/data/microbat/microbat.fa \
    -q intact/608_intact.fa \
    -b 608_best_hit.gff \
    -i 608_intact.fa \
    -o final \
    -T temp \
    -k \
    -v
