"""exclude high similarity sequences"""
import sys
import os
import subprocess
from Bio import SeqIO

HIGHEST_SIMILARITY = 50  # percent

if len(sys.argv) < 2:
    sys.stderr.write(
        "Usage: %s <infile.fa> [-v verbose]\n" % os.path.basename(sys.argv[0]))
    sys.exit(1)


def identity(needle_out):
    for line in open(needle_out):
        if 'Identity' in line:
            ident = float(
                line.split('(')[1].split('%')[0].strip())
            break
    return ident

# make temporary dir
p = subprocess.Popen(
    'mktemp -d ' + 'tmpXXXXXXXX', shell=True, stdout=subprocess.PIPE)
temp_dir = p.communicate()[0].split('\n')[0]


seq_handle = sys.argv[1]
VERBOSE = False
if len(sys.argv) > 2:
    if sys.argv[2] == "-v":
        VERBOSE = True
remove_list = []
seq_list = list(SeqIO.parse(seq_handle, "fasta"))
# save sequence by name
for i in xrange(0, len(seq_list)):
    outfile = temp_dir + "/" + "ORs_" + str(i + 1) + ".fa"
    SeqIO.write(seq_list[i], outfile, "fasta")

# print("qseqno\tsseqno\tqseqid\tsseqid\tsimilarity")
for i in xrange(0, len(seq_list) - 1):
    for j in xrange(i + 1, len(seq_list)):
        # align
        query = temp_dir + "/" + "ORs_" + str(i + 1) + ".fa"
        subject = temp_dir + "/" + "ORs_" + str(j + 1) + ".fa"
        needle_out = temp_dir + "/" + "needle_out.txt"
        SeqIO.write(seq_list[i], query, "fasta")
        SeqIO.write(seq_list[j], subject, "fasta")
        p = subprocess.Popen(
            'needle -gapopen 10.0 -gapextend 0.5 -outfile ' + needle_out +
            ' -asequence ' + query + ' -bsequence ' + subject +
            ' 2> /dev/null', shell=True)
        os.waitpid(p.pid, 0)
        # check identity
        ident = identity(needle_out)
        if ident > HIGHEST_SIMILARITY:
            if VERBOSE:
                sys.stderr.write(
                    "\t".join([str(i + 1), str(j + 1), seq_list[i].id,
                               seq_list[j].id, str(ident), "high"]) + "\n")
            remove_list.append(seq_list[i])
            break
        else:
            if VERBOSE:
                sys.stderr.write(
                    "\t".join([str(i + 1), str(j + 1), seq_list[i].id,
                               seq_list[j].id, str(ident), "low"]) + "\r")
# remove high similarity sequences
for record in remove_list:
    seq_list.remove(record)
# output low similarity sequences
for record in seq_list:
    print(record.format("fasta"))
# clean
p = subprocess.Popen(
    'rm -r ' + temp_dir, shell=True)
os.waitpid(p.pid, 0)

'''
for i in xrange(0, len(seq_list) - 1):
    if seq_list[i].id in remove_list:
        continue
    for j in xrange(i + 1, len(seq_list)):
        if seq_list[j].id in remove_list:
            continue
        # print("\t".join([seq_list[i].id, seq_list[j].id]))
        query = "needle_query.fa"
        subject = "needle_subject.fa"
        needle_out = "needle_out.txt"
        SeqIO.write(seq_list[i], query, "fasta")
        SeqIO.write(seq_list[j], subject, "fasta")
        # SeqIO.write(seq_list[i], sys.stdout, "fasta")
        # SeqIO.write(seq_list[j], sys.stdout, "fasta")

        p = subprocess.Popen(
            'needle -gapopen 10.0 -gapextend 0.5 -outfile ' + needle_out +
            ' -asequence ' + query + ' -bsequence ' + subject, shell=True)
        os.waitpid(p.pid, 0)

        for line in open(needle_out):
            if 'Identity' in line:
                identity = float(
                    line.split('(')[1].split('%')[0].strip()) / 100
                if identity > HIGHEST_SIMILARITY:
                    print("\t".join([seq_list[i].id,
                                     seq_list[j].id, str(identity),
                                     "remove_list"]))
                    remove_list.append(seq_list[j].id)
                break
p = subprocess.Popen(
    'rm ' + query + ' ' + subject + ' ' + needle_out)
os.waitpid(p.pid, 0)
'''
# End script
