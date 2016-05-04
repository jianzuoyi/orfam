#!/usr/bin/env python

import argparse

from Bio import SeqIO


def _translate(args):
    for record in SeqIO.parse(args.fasta, 'fasta'):
        print(">" + record.id)
        print(record.seq.translate())


def _extract(args):
    extract_ids = []
    for line in args.ids:
        if len(line.strip()) > 0:
            extract_ids.append(line.strip())
    for record in SeqIO.parse(args.fasta, 'fasta'):
        if record.id in extract_ids:
            print(record.format('fasta'))


def _exclude(args):
    complement_ids = []
    for line in args.ids:
        if len(line.strip()) > 0:
            complement_ids.append(line.strip())
    for record in SeqIO.parse(args.fasta, 'fasta'):
        if record.id not in complement_ids:
            print(record.format('fasta'))

if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        description="FASTA sequence manipulation tools")
    subparser = parser.add_subparsers(help="sub-commands")

    # parse translation arguments
    parser_translate = subparser.add_parser(
        'translate', help=("translate FASTA file"))
    parser_translate.add_argument(
        'fasta', type=argparse.FileType('r'), help=("FASTA file"))
    parser_translate.set_defaults(func=_translate)

    parser_extract = subparser.add_parser(
        'extract', help=("extract sequence by ids"))
    parser_extract.add_argument(
        'fasta', type=argparse.FileType('r'), help=("FASTA file"))
    parser_extract.add_argument(
        'ids', type=argparse.FileType('r'), help=("one id in each line"))
    parser_extract.set_defaults(func=_extract)

    parser_exclude = subparser.add_parser(
        'exclude', help=("exclude sequence by ids"))
    parser_exclude.add_argument(
        'fasta', type=argparse.FileType('r'), help=("FASTA file"))
    parser_exclude.add_argument(
        'ids', type=argparse.FileType('r'), help=("one id in each line"))
    parser_exclude.set_defaults(func=_exclude)

    # Parse arguments and run the sub-command
    args = parser.parse_args()
    args.func(args)
