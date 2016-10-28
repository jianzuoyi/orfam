#!/usr/bin/env python
import argparse

from Bio import SeqIO
from Bio import AlignIO


def find_tm(tm_seq, ref_ma):
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


def find_tms(ref_seq, ref_tms, ref_seq_msa):
    ref_tms_aln = []
    for tm in ref_tms:
        tm_seq = ref_seq[tm[1] - 1:tm[2]]
        new_tm = find_tm(tm_seq, ref_seq_msa)
        ref_tms_aln.append((tm[0], new_tm[0], new_tm[1]))
    return ref_tms_aln


def assign_tm1_left(genes, record_id, tm1_left_aa):
    for gene in genes:
        bed_id = gene[0] + ":" + \
            str(int(gene[3]) - 1) + "-" + gene[4] + "(" + gene[6] + ")"
        if bed_id == record_id:
            if gene[6] == '+':
                tm1_left = int(gene[3]) + ((tm1_left_aa * 3 - 2) - 1)
                gene[3] = str(tm1_left)
            else:
                tm1_left = int(gene[4]) - ((tm1_left_aa * 3 - 2) - 1)
                gene[4] = str(tm1_left)
            return gene


def assign_start_codon(in_genome, in_ORFs_aln, in_or_ref, in_or_ref_tm):
    alignment = AlignIO.read(in_ORFs_aln, "fasta")
    or_ref = SeqIO.read(in_or_ref, "fasta")
    or_ref_tms = []
    for tm in in_or_ref_tm:
        cols = tm.rstrip().split()
        assert(len(cols) == 3)
        or_ref_tms.append((cols[0], int(cols[1]), int(cols[2])))

    # find Tms of reference
    for record in alignment:
        if record.id == or_ref.id:
            or_ref_msa = record
            break
    or_ref_tms_aln = find_tms(or_ref.seq, or_ref_tms, or_ref_msa.seq)
    TM1 = or_ref_tms_aln[0]
    genome = SeqIO.to_dict(SeqIO.parse(in_genome, "fasta"))
    upstream = alignment[:, :TM1[1] - 1]
    downstream = alignment[:, TM1[1] - 1:]
    for i in xrange(0, len(upstream)):
        record = upstream[i]
        record_down = downstream[i]
        if record.id == or_ref.id:
            continue

        # get ORF information
        up_seq = str(record.seq).replace("-", "")
        up_seq_len = len(up_seq)
        # print(up_seq_len)
        chrom = record.id.split(":")[0]
        start = int(record.id.split(":")[1].split("(")[0].split("-")[0]) + 1
        end = int(record.id.split(":")[1].split("(")[0].split("-")[1])
        strand = record.id.split("(")[1].split(")")[0]
        # get upstream regions
        chrom_tm1_start = -1
        chrom_tm1_upstream = ""
        if up_seq_len == 0:
            # count gaps
            gaps = 0
            j = 0
            while str(record_down.seq)[j] == "-":
                gaps += 1
                j += 1

        if strand == "+":
            if up_seq_len > 0:
                chrom_tm1_start = start + up_seq_len * 3
            else:
                chrom_tm1_start = start - gaps * 3
            chrom_tm1_upstream = genome[chrom].seq[
                chrom_tm1_start - 1 - 100 * 3:chrom_tm1_start - 1].translate()
        else:
            if up_seq_len > 0:
                chrom_tm1_start = end - up_seq_len * 3
            else:
                chrom_tm1_start = end + gaps * 3
            chrom_tm1_upstream = genome[chrom].seq[
                chrom_tm1_start:chrom_tm1_start + 100 * 3].reverse_complement().translate()
        chrom_tm1_upstream = str(chrom_tm1_upstream)
        # exclude nonsense mutation
        star_pos = chrom_tm1_upstream.rfind("*")
        chrom_tm1_upstream = chrom_tm1_upstream[star_pos + 1:]
        '''
        print(chrom, start, end, strand, chrom_tm1_start, len(chrom_tm1_upstream))
        print("-"*(len(chrom_tm1_upstream)-up_seq_len) + up_seq)
        print(chrom_tm1_upstream)
        '''
        # check start codon in regions
        region_a = chrom_tm1_upstream[:-34]
        region_b = chrom_tm1_upstream[-34:-20]
        region_c = chrom_tm1_upstream[-20:]
        M_in_region_a = "M" in region_a
        M_in_region_b = "M" in region_b
        M_in_region_c = "M" in region_c
        '''
        print("a",region_a, M_in_region_a)
        print("b",region_b, M_in_region_b)
        print("c",region_c, M_in_region_c)
        '''
        # assign proper initiation codon
        if M_in_region_b:
            # choose the most downstream one
            M_pos = region_b.rfind("M")
            M_pos_downstream = 20 + (len(region_b) - M_pos)
        elif M_in_region_a:
            # choose the most downstream one
            M_pos = region_a.rfind("M")
            M_pos_downstream = 34 + (len(region_a) - M_pos)
        elif M_in_region_c:
            # choose the most upstream one
            M_pos = region_c.find("M")
            M_pos_downstream = len(region_c) - M_pos
        if M_in_region_a or M_in_region_b or M_in_region_c:
            if strand == "+":
                start = chrom_tm1_start - M_pos_downstream * 3
                # check nonsensen mutation
                cds = str(genome[chrom].seq[start - 1:end].translate())
                star_pos = cds[:-1].find("*")
                if star_pos != -1:
                    M_pos = cds.find("M", star_pos + 1)
                    start = start + M_pos * 3
            else:
                end = chrom_tm1_start + M_pos_downstream * 3
                cds = str(
                    genome[chrom].seq[
                        start - 1:end].reverse_complement().translate())
                star_pos = cds[:-1].find("*")
                if star_pos != -1:
                    M_pos = cds.find("M", star_pos + 1)
                    end = end - M_pos * 3

        # output (GFF format)
        line = [chrom, "start_codon", "ORF",
                str(start), str(end), "0.0", strand, ".", "."]
        if abs(end - start)/3 >= 250 and abs(end-start)/3 <= 450:
            print("\t".join(line))


if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        description="Assignment of a proper initiation codon")
    parser.add_argument(
        '--genome', type=argparse.FileType('r'),
        required=True, help=("Genome file (FASTA)"))
    parser.add_argument(
        '--orf_aln', type=argparse.FileType('r'), required=True,
        help=("OR reference sequence (Results of multiple alignment)"))
    parser.add_argument(
        '--or_ref', type=argparse.FileType('r'),
        required=True, help=("OR reference sequence (FASTA)"))
    parser.add_argument(
        '--or_ref_tm', type=argparse.FileType('r'),
        required=True, help=("TMs of OR reference sequence (BED)"))

    args = parser.parse_args()
    assign_start_codon(
        args.genome, args.orf_aln, args.or_ref, args.or_ref_tm)
