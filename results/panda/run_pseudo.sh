#!/bin/bash

time orfam pseudo \
    -s ../../data/panda/ailMel1.fa \
    -q intact/608_intact.fa \
    -b 608_best_hit.gff \
    -i 608_intact.fa \
    -o final_ \
    -T temp \
    -k \
    -v
