#!/usr/bin/env python

"""
pseudogene - identifying olfactory receptor pseudogenes of mammalian
"""

import sys
import os
import argparse
import subprocess
from Bio import SeqIO
from Bio.Seq import Seq
from Bio.SeqRecord import SeqRecord
from Bio.Alphabet import IUPAC

import warnings
from Bio import BiopythonExperimentalWarning

with warnings.catch_warnings():
    warnings.simplefilter('ignore', BiopythonExperimentalWarning)
    from Bio import SearchIO


def _get_hit_record(ref_record, hit, flank=0):
    start = int(hit[3]) - flank
    end = int(hit[4]) + flank
    record_len = len(ref_record.seq)
    # consider the start and end out of the sequence
    start = max(1, start)
    end = min(end, record_len)
    # slice record sequence and fetch sub seq
    seq = ref_record.seq[start - 1:end]

    seq_id = hit[0] + ":" + str(start - 1) + "-" + str(end)
    if hit[6] == "+":
        seq_id = seq_id + "(+)"
    else:
        seq_id = seq_id + "(-)"
        seq = seq.reverse_complement()
    hit_record = SeqRecord(
        seq, id=seq_id, name=seq_id,
        description="hit with %sbp flanking sequence" % flank)

    return hit_record


def _save_hit(hit_file, hits):
    fout = open(hit_file, "w")
    for hit in hits:
        fout.write("\t".join(hit))
        fout.write("\n")
    fout.close()


def _six_frame_translation(record):
    translations = []
    seq_len = len(record.seq)
    for strand, nuc in [("+", record.seq),
                        ("-", record.seq.reverse_complement())]:
        for frame in [0, 1, 2]:
            trans_len = ((seq_len - frame) // 3) * 3
            trans = str(nuc[frame:frame + trans_len].translate()).upper()
            if strand == "+":
                new_id = record.id + "_" + str(frame + 1)
            else:
                new_id = record.id + "_" + str(frame + 4)
            new_record = SeqRecord(Seq(trans, IUPAC.protein), id=new_id,
                                   name=new_id, description="translation")
            translations.append(new_record)
    return translations


def _is_pseudogene(intacts, translations):
    is_pseudo = True
    for intact in intacts:
        for translation in translations:
            if intact.seq in translation.seq:
                # print(intact.id)
                is_pseudo = False

    return is_pseudo


def find_pseudogene(sbjct_dict, best_hits, intact_genes, out_pseudo_hit):
    sys.stderr.write("finding pseudogenes...\n")

    pseudo_hits = []

    for hit in best_hits:
        chrom = hit[0]
        record = sbjct_dict[chrom]
        # add get sequence with flanking end
        flank_record = _get_hit_record(record, hit, 1000)
        # six frame translation
        translations = _six_frame_translation(flank_record)
        """
        if hit[0] == "chr15" and hit[3] == '98862582':
            SeqIO.write(translations, sys.stdout, "fasta")
            print("is pseudogene", _is_pseudogene(intact_genes, translations))
            raise
        """
        if _is_pseudogene(intact_genes, translations):
            pseudo_hits.append(hit)

    _save_hit(out_pseudo_hit, pseudo_hits)
    sys.stderr.write("done.\n")
    return pseudo_hits


def find_nonsense(sbjct_dict, pseudo_hits, out_nonsense):
    sys.stderr.write("finding nonsense mutations...\n")
    nonsense_mutations = []
    non_nonsense = []

    for hit in pseudo_hits:
        chrom = hit[0]
        record = sbjct_dict[chrom]
        hit_record = _get_hit_record(record, hit)
        if "*" in hit_record.seq.translate():
            nonsense_mutations.append(hit_record)
        else:
            non_nonsense.append(hit)

    SeqIO.write(nonsense_mutations, out_nonsense, "fasta")
    sys.stderr.write("done.\n")
    return non_nonsense


def find_frameshift(sbjct_dict, query_dict, pseudo_hits,
                    temp_dir, out_frameshift):
    assert(os.path.isdir(temp_dir))
    sys.stderr.write("finding frameshift mutations...\n")

    frameshifts = []
    non_frameshift = []
    exn_query = temp_dir + "/" + "exn_query.fa"
    exn_target = temp_dir + "/" + "exn_target.fa"
    align_file = temp_dir + "/" + "fshift_exonerate.exn"

    for hit in pseudo_hits:
        chrom = hit[0]
        record = sbjct_dict[chrom]
        qseqid = hit[8].split(";")[0].split("=")[1]
        SeqIO.write(query_dict[qseqid], exn_query, "fasta")
        flank = 1000
        flank_record = _get_hit_record(record, hit, flank)
        SeqIO.write(flank_record, exn_target, "fasta")

        # alignment using exonerate
        p = subprocess.Popen("exonerate -m protein2dna -n 1 -q " +
                             exn_query + " -t " + exn_target + ">" +
                             align_file, shell=True)
        os.waitpid(p.pid, 0)
        fshift = False

        try:
            qresult = SearchIO.read(align_file, "exonerate-text")
            hsp = qresult[0][0]  # first hit, first hsp
            # query overlapping with the best-hit
            new_hit_start = flank + 1
            new_hit_end = len(flank_record.seq) - flank
            if hsp.hit_start + 1 <= new_hit_end and \
                    hsp.hit_end >= new_hit_start:
            # there are frameshifts
                if len(hsp.hit_frame_all) > 1:
                    fshift = True
        except:
            pass

        if fshift:
            fshift_seq = flank_record.seq[hsp.hit_start:hsp.hit_end]
            fshift_id = hit[0] + ":" + \
                str(hsp.hit_start + 1) + "-" + str(hsp.hit_end)
            frameshift_record = SeqRecord(
                fshift_seq, id=fshift_id, name=fshift_id,
                description="qseqid=" + qseqid)
            frameshifts.append(frameshift_record)
        else:
            non_frameshift.append(hit)
    # end for

    SeqIO.write(frameshifts, out_frameshift, "fasta")
    sys.stderr.write("done.\n")
    return non_frameshift


def find_truncated(sbjct_dict, pseudo_hits, out_truncated, out_others):
    sys.stderr.write("finding truncated genes...\n")
    truncations = []
    pseudo_others = []

    for hit in pseudo_hits:
        chrom = hit[0]
        record = sbjct_dict[chrom]
        record_seq_len = len(record.seq)

        truncated = False
        hit_start = int(hit[3])
        hit_end = int(hit[4])
        distance_5_end = hit_start - 1
        distance_3_end = record_seq_len - hit_end
        if distance_5_end < 30 or distance_3_end < 30:
            truncated = True
        if truncated:
            truncations.append(hit)
        else:
            pseudo_record = _get_hit_record(record, hit)
            pseudo_others.append(pseudo_record)

    _save_hit(out_truncated, truncations)
    SeqIO.write(pseudo_others, out_others, "fasta")
    sys.stderr.write("done.\n")
    return pseudo_others


def main(args):
    sbjct_dict = SeqIO.to_dict(SeqIO.parse(args.subject, "fasta"))
    query_dict = SeqIO.to_dict(SeqIO.parse(args.query, "fasta"))
    intact_genes = list(SeqIO.parse(args.intact, "fasta"))
    best_hits = []
    for hit in open(args.best):
        best_hits.append(hit.strip().split())

    # make temporary dir
    temp_dir = args.tempdir
    if temp_dir:
        p = subprocess.Popen('mkdir -p ' + temp_dir, shell=True)
        os.waitpid(p.pid, 0)
    else:
        p = subprocess.Popen(
            'mktemp -d ' + 'tmpXXXXXXXX', shell=True, stdout=subprocess.PIPE)
        temp_dir = p.communicate()[0].split('\n')[0]

    # output files
    out_pseudo_all = args.output + "pseudo.gff"
    out_nonsense = args.output + "pseudo_nonsense.fa"
    out_frameshift = args.output + "pseudo_frameshift.fa"
    out_truncated = args.output + "truncated.gff"
    out_others = args.output + "pseudo_others.fa"

    # identify pseudogenes
    pseudo_hits = find_pseudogene(
        sbjct_dict, best_hits, intact_genes, out_pseudo_all)
    #print("pseudogenes", len(pseudo_hits))
    #raise
    non_nonsense = find_nonsense(
        sbjct_dict, pseudo_hits, out_nonsense)
    non_frameshift = find_frameshift(
        sbjct_dict, query_dict, non_nonsense, temp_dir, out_frameshift)
    find_truncated(
        sbjct_dict, non_frameshift, out_truncated, out_others)

    # clean
    p = subprocess.Popen("rm -rf " + temp_dir, shell=True)
    os.waitpid(p.pid, 0)

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description="identify pseudogenes")
    parser.add_argument("-s", "--subject", type=str, required=True,
                        help=("subject genome (FASTA)"))
    parser.add_argument("-q", "--query", type=str, required=True,
                        help=("query olfactory receptors (FASTA)"))
    parser.add_argument("-b", "--best", type=str, required=True,
                        help=("best hits file (GFF)"))
    parser.add_argument("-i", "--intact", type=str, required=True,
                        help=("intact olfactory receptors (FASTA)"))
    parser.add_argument("-o", "--output", type=str, required=False,
                        help=("output prefix"))
    parser.add_argument("-T", "--tempdir", type=str, required=False,
                        help=("temporary dir"))
    parser.set_defaults(func=main)

    args = parser.parse_args()
    args.func(args)
