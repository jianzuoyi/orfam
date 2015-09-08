'''
EVAN	2015
'''

import sys
from Bio.Seq import Seq
from Bio.Alphabet import IUPAC
from Bio import SeqIO

def ExtendCodingSequence():
	pass
def intact():
	pass

def truncate():
	pass

def pseudogene():
	pass
	
def main():
	if len(sys.argv) < 3:
		sys.stderr.write("Usage: fastatool.py <sub_command> <in.blast.gff>\n")
		sys.exit()

if __name__ == '__main__':
	main()