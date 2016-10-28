#!/bin/bash

time orfam pseudo \
    -s ../../data/mm3/Mus_musculus.mm3.fa \
    -q ../../data/ORs/Mus_musculus_ORs.fa \
    -b new_album.gff \
    -i new_intact.fa \
    -o new_ \
    -T temp \
    -k \
    -v
