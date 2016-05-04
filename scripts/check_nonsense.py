import sys
from Bio import SeqIO

for record in SeqIO.parse(sys.argv[1], "fasta"):
    cnt = record.seq.count("*")
    print("\t".join([record.id, str(cnt)]))
