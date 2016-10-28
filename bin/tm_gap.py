#!/usr/bin/env python

import argparse
from Bio import SeqIO
from Bio import AlignIO


def _tm(tm_seq, ref_ma):
    for i, x in enumerate(ref_ma):
        if x == tm_seq[0]:
            start = i + 1
            stop = 0
            window = ''
            for i, x in enumerate(ref_ma[i:]):
                if x != '-':
                    window = window + x
                    if len(window) == len(tm_seq):
                        stop = start + i
                        break
            if window == tm_seq:
                return start, stop


def find_tms(ref_seq, ref_tms, ref_seq_aln):
    ref_tms_aln = []
    for tm in ref_tms:
        tm_seq = ref_seq[tm[1] - 1:tm[2]]
        tm_aln = _tm(tm_seq, ref_seq_aln)
        ref_tms_aln.append((tm[0], tm_aln[0], tm_aln[1]))
    return ref_tms_aln


def exclue_tm_long_gap(in_ref_or, in_ref_or_tm, in_orf_aln):
    ref_or = SeqIO.read(in_ref_or, "fasta")
    ref_or_tms = []
    for line in in_ref_or_tm:
        cols = line.rstrip().split()
        assert(len(cols) == 3)
        ref_or_tms.append((cols[0], int(cols[1]) + 1, int(cols[2])))
    alignment = AlignIO.read(in_orf_aln, "fasta")
    ref_or_index = -1
    for i in xrange(0, len(alignment)):
        if alignment[i].id == ref_or.id:
            ref_or_index = i
            break

    tms_aln = find_tms(
        ref_or.seq, ref_or_tms, alignment[ref_or_index].seq)
    # for tm in tms_aln:
    #    print(tm)
    remove_names = [alignment[ref_or_index].id]
    for tm in tms_aln:
        tm_start = tm[1]
        tm_end = tm[2]
        tm_align = alignment[:, tm_start - 1:tm_end]
        tm_align_ref_or = tm_align[ref_or_index]
        for record in tm_align:
            tm_gaps = 0
            for i in xrange(0, len(record.seq)):
                if tm_align_ref_or[i] != "-" and record.seq[i] == "-":
                    tm_gaps += 1
            if tm_gaps > 4:
                remove_names.append(record.id)
                # print(record.format("fasta"))
                # print(tm_align_ref_or.format("fasta"))

    # remove sequences which have long (>=5) gap with a TM
    for record in alignment:
        if record.id not in remove_names:
            chrom = record.id.split(":")[0]
            start = int(
                record.id.split(":")[1].split("(")[0].split("-")[0]) + 1
            end = int(record.id.split(":")[1].split("(")[0].split("-")[1])
            strand = record.id.split("(")[1].split(")")[0]
            # output (GFF format)
            line = [chrom, "tm_long_gap", "ORF",
                    str(start), str(end), "0.0", strand, ".", "."]
            print("\t".join(line))


if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        description="exclude OR candidates which have \
        long gaps within transmembrance regions")
    parser.add_argument(
        '--ref_or', type=argparse.FileType('r'), required=True,
        help=("OR reference sequence (FASTA format)"))
    parser.add_argument(
        '--ref_or_tm', type=argparse.FileType('r'), required=True,
        help=("TMs of OR reference sequence (BED format)"))
    parser.add_argument(
        '--orf_aln', type=argparse.FileType('r'), required=True,
        help=("Open Reading Frame (Results of multiple sequence alignment)"))

    args = parser.parse_args()
    exclue_tm_long_gap(args.ref_or, args.ref_or_tm, args.orf_aln)
