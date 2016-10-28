import sys
import os
import subprocess
from Bio import SeqIO

query = "query.fa"
subject = "known_specity_gene.fa"
needle_out = "needle_out.txt"

for record in SeqIO.parse("moschus_specific_gene.fa", "fasta"):
    SeqIO.write(record, query, "fasta")
    p = subprocess.Popen(
        'needle -gapopen 10.0 -gapextend 0.5 -outfile ' + needle_out +
        ' -asequence ' + query + ' -bsequence ' + subject, shell=True)
    os.waitpid(p.pid, 0)

    for line in open(needle_out):
        if '# 1:' in line:
            qry = line.strip().split()[2]
        if '# 2:' in line:
            sbj = line.strip().split()[2]
        if 'Identity' in line:
            identity = float(
                line.split('(')[1].split('%')[0].strip())
            # print(identity)
            if identity >= 60:
                print(qry + " " + sbj + " " + str(identity))
