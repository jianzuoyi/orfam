#!/bin/bash

BEST_HITS=$(cat best_hits.gff | wc -l)
INTACT=$(cat intact.fa | grep '^>' | wc -l)
TRUNCATED=$(cat truncated.gff | wc -l)
NONSENSE=$(cat pseudogene_nonsense.fa | grep '^>' | wc -l)
FRAMESHIFT=$(cat pseudogene_frameshift.fa | grep '^>'  | wc -l)
PSEUDO_OTHERS=$(cat pseudogene_others.fa | grep '^>' | wc -l)
((PSEUDO=NONSENSE+FRAMESHIFT+PSEUDO_OTHERS))
echo -e "\tintact\tpseudo\ttruncated" > summary.txt
echo -e "\t$INTACT\t$NONSENSE\t$TRUNCATED" >> summary.txt
echo -e "\t\t$FRAMESHIFT" >> summary.txt
echo -e "\t\t$PSEUDO_OTHERS" >> summary.txt
echo -e "total\t$INTACT\t$PSEUDO\t$TRUNCATED" >> summary.txt


