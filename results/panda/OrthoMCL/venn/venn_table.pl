#!/usr/bin/perl  -w

=head1 name

venn_table.pl

=head1 Description

generate data for drawing venn figure of 4 groups of species;

=head1 Version

 Author: Wenbin Liu, liuwenbin@genomics.org.cn
 Version: 1.0,  Date: 2010-04-25

=head1 Usage

 perl venn_table.pl <file> [options]
  <file>                input file, eg. all_vs_all.blast.m8.solar.forHC.hcluster.stat
  --select_spe <str>    how to classify species into 4 groups. column index
                        number(start with 0) of species should be set. 
                        default="2,3;4,5;6,7;8,9"
  --con_type <and/or>   consolidation method to calculate the gene number in an 
                        orthologous group, while you select "and" all the species
                        in a spe_group share a gene we calculate 1, select "or", 
                        more than one species have the gene we calculate 1,
                        default="and"
  --help                output help information to screen

=head1 Notice

 Results of this script can be taken as input to draw figure by:
   /home/wujiao/perl5/fig/ellipse_venn_figure.pl

=head1 Example

 perl venn_table.pl ./all_vs_all.blast.m8.solar.forHC.hcluster.stat 
   --select_spe "2;3;4;5" > G.mar_ven_table

=cut

## Revised by Wang Zhuo, wangzhuo@genomics.org.cn
## 2010-09-30

use strict;
use Getopt::Long;
my ($select_spe, $con_type, $help);
GetOptions(
    "select_spe:s" => \$select_spe,
    "con_type:s"   => \$con_type,
    "help"         => \$help
);
die `pod2text $0` if (@ARGV != 1);

# Instructions:
# venn_posit     -- the position of the data in the venn table
# 
# select_spe     -- the species you select to stats venn data
# spe_name       -- the name of the species
# spe_latin_name -- the latin name of the species
# venn_data      -- the array store the venn table data of the species
# table_caption1 -- the information in the first row of the venn table
# table_caption2 -- the information in the first column of the venn table
# 
# latin_name      --change the species name into latin name
# venn_position   --The function used to decide the position of the data in the venn table
#


my $file = shift;
open IN, $file;
$select_spe ||= "2,3;4,5;6,7;8,9";
my @line           = split /\s+/, <IN>;
my @spe_latin_name = latin_name(@line);
my @spe_name       = spe_group($select_spe, @spe_latin_name);
my @tol_spe        = (split /[,;]/, $select_spe);
my @tol_spe_name   = @spe_latin_name[@tol_spe];
my @tol_gene_num;
my (@venn_data, $venn_posit);
$con_type ||= "and";

while (<IN>) {
    @line = split /\s+/, $_;
    my @con_group;
    if ($con_type eq "and") {
        @con_group = more_conv($select_spe, @line);
    } elsif ($con_type eq "or") {
        @con_group = more_sum($select_spe, @line);
    } else {
        print "pleses select con_type(and/or)\n";
        chmod($con_type = <STDIN>);
        redo;
    }
    $venn_posit = venn_position(@con_group);
    $venn_data[$venn_posit]++;
    if ($venn_posit == 5) {
        foreach (0 .. @tol_spe - 1) {
            $tol_gene_num[$_] += $line[ $tol_spe[$_] ];
        }
    }
}
close IN;

## creat the venn table
print "@spe_name\n";
for my $i (0 .. 3) {
    for my $j (0 .. 3) {
        $i + $j == 6 && last;
        $venn_data[ $j + 4 * $i ] ||= 0;
        print "$venn_data[$j + 4 * $i]\t";
    }
    print "\n"
}

# Change some species name into latin name
sub latin_name {
    foreach (@_) {
        $_ =
          $_ eq "URSMA" ? 'U.mar' :
          $_ eq "PANDA" ? 'A.mel' :
          $_ eq "HUMAN" ? 'H.sap' :
          $_ eq "MOUSE" ? 'M.mus' :
          $_ eq "CANFA" ? 'C.fam' :
          $_ eq "FELCA" ? 'F.cat' :
          $_ eq "MONDO" ? 'M.dom' :
          $_ eq "ORNAN" ? 'O.ana' :
          $_ eq "PANTR" ? 'P.tro' :
          $_ eq "BOVIN" ? 'B.tau' :
          $_ eq "MACMU" ? 'M.mul' :
          $_ eq "HORSE" ? 'E.cab' :
          $_ eq "SUSSC" ? 'S.scr' :
          $_ eq "RATNO" ? 'R.nor' : $_;
    }
    @_;
}

sub conv {
    my $conv_present = 1;
    foreach (@_) {
        $conv_present *= $_;
    }
    $conv_present;
}

sub more_conv {
    my $group = shift;
    my @result;
    my $i = 0;
    foreach my $sub_group (split /;/, $group) {
        $result[$i] = conv(@_[ (split /,/, $sub_group) ]);
        $i++;
    }
    @result;
}

sub sum {
    my $sum_present = 0;
    foreach (@_) {
        $sum_present += $_;
    }
    $sum_present;
}

sub more_sum {
    my $group = shift;
    my @result;
    my $i = 0;
    foreach my $sub_group (split /;/, $group) {
        $result[$i] = sum(@_[ (split /,/, $sub_group) ]);
        $i++;
    }
    @result;
}

# Show which species are in a group
sub spe_group {
    my $group = shift;
    my @result;
    my $i = 0;
    foreach my $sub_group (split /;/, $group) {
        foreach my $spe (split /,/, $sub_group) {
            $result[$i] .= "\*$_[$spe]";
        }
        $result[$i] =~ s/^\*//;
        $i++;
    }
    @result;
}

# Decide the position of the data in the venn table
sub venn_position {
    my $ven_pos1 =
      ($_[0] > 0 && $_[1] == 0) ? 0 :
      ($_[0] > 0 && $_[1] > 0)  ? 1 :
      ($_[0] == 0 && $_[1] > 0) ? 2 : 3;
    my $ven_pos2 =
      ($_[2] > 0 && $_[3] == 0) ? 0 :
      ($_[2] > 0 && $_[3] > 0)  ? 1 :
      ($_[2] == 0 && $_[3] > 0) ? 2 : 3;
    my $ven_pos = $ven_pos1 + 4 * $ven_pos2;
    $ven_pos;
}

