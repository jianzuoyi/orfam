#!bin/bash
#
# Blast output converion to GFF
#
# Ouch! requiring a BLAST+ tabular format which can be obtained by using the "-outfmt 6" option with the default columns.
#
#
blast_out=$1
cat $blast_out | awk -v OFS='\t' '{ if(($9<$10)) { strand="+" } else { strand="-"; tmp=$10; $10=$9; $9=tmp } print $2,"TBLASTN","similarity",$9,$10,$11,strand,".","qseqid="$1";qstart="$7";qend="$8";pident="$3";length="$4";mismatch="$5";gapopen="$6";bitscore="$12 }'