#!/bin/env python

import sys
import argparse
from Bio import Phylo


def root_with_outgroup(args):
    tree = Phylo.read(args.nwk, "newick")
    outgroup = []
    for line in args.outgroup:
        name = line.strip()
        if len(name) > 0:
            outgroup.append(tree.find_clades(name).next())

    if tree.is_monophyletic(outgroup):
        tree.root_with_outgroup(outgroup)
        # mrca = tree.common_ancestor(outgroup)
        # tree.root_with_outgroup(mrca)
        # Phylo.draw_ascii(tree)
        # print(tree)
        Phylo.write(tree, sys.stdout, "newick")
    else:
        sys.stderr.write("Error: outgroup is no a monophyletic clade")
        sys.exit(1)

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description="root a tree with outgroup")
    parser.add_argument(
        "nwk", type=argparse.FileType('r'), help=("newick file"))
    parser.add_argument(
        "outgroup", type=argparse.FileType('r'), help=("genes of outgroup"))

    args = parser.parse_args()
    root_with_outgroup(args)
