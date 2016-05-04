import sys
from Bio import SeqIO

for record in SeqIO.parse(sys.argv[1], "fasta"):
    if record.seq[0] == "M" and "*" ==  record.seq[-1]:
        # SeqIO.write(record, sys.stdout, "fasta")
        pass
    else:
        SeqIO.write(record, sys.stdout, "fasta")
    
    if "*" in record.seq[:-1]:
        print("pseudogene")
        SeqIO.write(record, sys.stdout, "fasta")
