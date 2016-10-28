import sys
from Bio import SeqIO

pseudos = list(SeqIO.parse(sys.argv[2], "fasta"))

for record in SeqIO.parse(sys.argv[1], "fasta"):
    for pseudo in pseudos:
        if record.seq in pseudo.seq:
            print("yes")
            SeqIO.write(record, sys.stdout, "fasta")
            SeqIO.write(pseudo, sys.stdout, "fasta")
            break
