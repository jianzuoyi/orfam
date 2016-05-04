"""Unit tests for functions of pseudogene."""

import os
import subprocess
import unittest
from Bio import SeqIO
import pseudogene

TEST_DIR = "pseudogene"


def get_file(filename):
    """Returns the path of a test file."""
    return os.path.join(TEST_DIR, filename)


class PseudogeneTests(unittest.TestCase):

    """Tests for functions of pseudogene"""

    def setUp(self):
        self.sbjct_dict = SeqIO.to_dict(
            SeqIO.parse(get_file("Mus_musculus.mm3.fa"), "fasta"))
        self.query_dict = SeqIO.to_dict(
            SeqIO.parse(get_file("Mus_musculus_ORs.fa"), "fasta"))
        self.intact_genes = list(SeqIO.parse(get_file("intact.fa"), "fasta"))
        self.temp_dir = "temp"
        p = subprocess.Popen('mkdir -p ' + self.temp_dir, shell=True)
        os.waitpid(p.pid, 0)

    def test_find_pseudogene(self):
        """Test find pseudogene"""

        best_hits = []
        for hit in open(get_file("best_hits.gff")):
            best_hits.append(hit.strip().split())

        out_pseudo = self.temp_dir + "/pseudo.gff"
        pseudo_hits = pseudogene.find_pseudogene(
            self.sbjct_dict, best_hits, self.intact_genes, out_pseudo)
        self.assertEqual(len(pseudo_hits), 447)

    def test_find_nonsense(self):
        """Test find nonsense mutation pseudogene"""

        in_pseudo_hit = get_file("pseudo.gff")
        pseudo_hits = []
        for hit in open(in_pseudo_hit):
            pseudo_hits.append(hit.strip().split())

        out_pseudo_nonsense = self.temp_dir + "/pseudo_nonsense.fa"
        pseudo_non_nonsense = pseudogene.find_nonsense(
            self.sbjct_dict, pseudo_hits, out_pseudo_nonsense)
        self.assertEqual(len(pseudo_non_nonsense), 265)

    def test_find_frameshift(self):
        """Test find frameshift mutation gene"""

        pseudo_hit = get_file("pseudo_non_nonsense.gff")
        pseudo_hits = []
        for hit in open(pseudo_hit):
            pseudo_hits.append(hit.strip().split())

        out_pseudo_frameshift = self.temp_dir + "/pseudo_frameshift.fa"
        pseudo_hits_no_frameshift = pseudogene.find_frameshift(
            self.sbjct_dict, self.query_dict, pseudo_hits, self.temp_dir,
            out_pseudo_frameshift)
        self.assertEqual(len(pseudo_hits_no_frameshift), 113)

    def test_find_truncated(self):
        """Test find truncated gene"""

        in_pseudo_hit = get_file("pseudo_non_frameshift.gff")
        pseudo_hits = []
        for hit in open(in_pseudo_hit):
            pseudo_hits.append(hit.strip().split())

        out_truncated = self.temp_dir + "/truncated.fa"
        out_pseudo_others = self.temp_dir + "/pseudo_others.fa"
        pseudo_others = pseudogene.find_truncated(
            self.sbjct_dict, pseudo_hits, out_truncated, out_pseudo_others)
        self.assertEqual(len(pseudo_others), 113)

    def tearDown(self):
        p = subprocess.Popen('rm -rf ' + self.temp_dir, shell=True)
        os.waitpid(p.pid, 0)

if __name__ == '__main__':
    runner = unittest.TextTestRunner(verbosity=2)

    test_suite = False
    # test suite
    if test_suite:
        suite = unittest.TestSuite()
        suite.addTest(PseudogeneTests("test_find_pseudogene"))
        suite.addTest(PseudogeneTests("test_find_nonsense"))
        suite.addTest(PseudogeneTests("test_find_frameshift"))
        suite.addTest(PseudogeneTests("test_find_truncated"))
        runner.run(suite)
    # test all
    else:
        unittest.main(testRunner=runner)
