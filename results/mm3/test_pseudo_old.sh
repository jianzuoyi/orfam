#!/bin/bash

time orfam pseudo \
    -s ../../data/mm3/Mus_musculus.mm3.fa \
    -q ../../data/ORs/Mus_musculus_ORs.fa \
    -b old_album.gff \
    -i old_intact.fa \
    -o old_ \
    -T temp \
    -k \
    -v
