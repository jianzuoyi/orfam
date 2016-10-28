import sys
import os
import subprocess
from Bio import SeqIO

sequences = list(SeqIO.parse(sys.argv[1], 'fasta'))

for record in sequences:
	print(record.id)

out = 'stretcher.out'

def identity(needle_out):
    for line in open(needle_out):
        if 'Identity' in line:
            ident = float(
                line.split('(')[1].split('%')[0].strip())
            break
    return ident

for i in xrange(0, len(sequences)):
	SeqIO.write(sequences[i], 'query.fa', "fasta")
	for j in xrange(0, len(sequences)):
		print(i, j)
		SeqIO.write(sequences[j], 'subject.fa', "fasta")
		
		p = subprocess.Popen('stretcher -asequence query.fa -bsequence subject.fa -outfile stretcher.out' +
            ' 2> /dev/null', shell=True)
        os.waitpid(p.pid, 0)

        ident = identity('stretcher.out')
        print(sequences[i].id),
        print(sequences[j].id),
        print(ident)