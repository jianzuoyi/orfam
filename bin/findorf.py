import argparse

from Bio import SeqIO


def orffinder(seq, min_protein_length):
    orfs = []
    seq_len = len(seq)

    for strand, nuc in [("+", seq), ("-", seq.reverse_complement())]:
        for frame in [0, 1, 2]:
            trans_len = ((seq_len - frame) // 3) * 3
            trans = str(nuc[frame:frame + trans_len].translate()).upper()
            aa_len = len(trans)
            aa_start = 0
            aa_stop = 0
            while aa_start < aa_len:
                aa_start = trans.find("M", aa_start)
                if aa_start == -1:
                    break
                aa_stop = trans.find("*", aa_start)
                if aa_stop == -1:
                    break
                if aa_stop - aa_start >= min_protein_length:
                    if "X" in trans[aa_start:aa_stop]:
                        break
                    if strand == "+":
                        dna_start = frame + aa_start * 3
                        dna_stop = frame + (aa_stop + 1) * 3
                    else:
                        dna_start = seq_len - (frame + (aa_stop + 1) * 3)
                        dna_stop = seq_len - (frame + aa_start * 3)

                    orfs.append((dna_start + 1, dna_stop, strand))

                aa_start = aa_stop + 1
    orfs.sort()
    return orfs


def getsubseq(seq, start, end, flank):
    seq_len = len(seq)
    seq_start = max(0, start - flank)
    seq_end = min(end + flank, seq_len)
    return seq_start, seq_end, seq[seq_start - 1:seq_end]


def findorf(args):
    ref_dict = SeqIO.to_dict(SeqIO.parse(args.reference, "fasta"))
    for line in args.hit:
        hit = line.rstrip().split()
        chrom = hit[0]
        ref_record = ref_dict[chrom]
        flank = 1000
        ref_start, ref_stop, seq = getsubseq(
            ref_record.seq, int(hit[3]), int(hit[4]), flank)
        orfs = orffinder(seq, 250)
        for orf_start, orf_stop, strand in orfs:
            orf = [ref_record.id, "findorf", "ORF",
                   str(ref_start + (orf_start - 1)),
                   str(ref_start + (orf_stop - 1)),
                   "0.0", strand, ".", "."]
            print('\t'.join(orf))


if __name__ == '__main__':
    parser = argparse.ArgumentParser("find open reading frame")
    parser.add_argument(
        "reference", type=argparse.FileType("r"),
        help=("FASTA    reference genome, FASTA format"))
    parser.add_argument(
        "hit", type=argparse.FileType("r"), help=("GFF  blast output"))

    args = parser.parse_args()
    findorf(args)
