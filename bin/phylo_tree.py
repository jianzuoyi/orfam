#!/usr/bin/env python

__version__ = 1.0

INFO = """
phylo_tree - exclude non-OR genes on the basis of the phylogenetic tree. when a given sequence is located
in the outgroup clade, it should be discard.
version: %s

Zuoyi Jian (jianzuoyi@gmail.com)
lab 518, Conservation Biology on Endangered Wildlife, SiChuan University
""" % __version__

import sys
import argparse
from Bio import Phylo


def phylo_tree(args):
    tree = Phylo.read(args.nwk, "newick")
    terminals = tree.get_terminals()
    outgroup = []
    orgroup = []

    for line in args.outgroup:
        outgroup_or = line.strip()
        if len(outgroup_or) > 0:
            outgroup.append(tree.find_clades(line.strip()).next())

    for terminal in terminals:
        if terminal not in outgroup:
            orgroup.append(terminal)

    # If genes with that in the outgroup share one MRCA, it may be a non-OR
    # gene and will be discarded.
    if not tree.is_monophyletic(outgroup):
        mrca = tree.common_ancestor(outgroup)
        terminals = mrca.get_terminals()
        for terminal in terminals:
            if terminal in orgroup:
                print(terminal.name)

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=INFO)
    parser.add_argument(
        "nwk", type=argparse.FileType('r'), help=("newick file"))
    parser.add_argument(
        "outgroup", type=argparse.FileType('r'),
        help=("gene names of outgroup"))

    args = parser.parse_args()
    phylo_tree(args)
