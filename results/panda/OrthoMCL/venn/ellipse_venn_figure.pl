#!/usr/bin/perl

=head1 Name

 ellipse_venn_figure.pl

=head1 Description

 Read in the file contains data of shared orthologous gene cluster 
 numbers among four species groups, which calculated by venn_table.pl, 
 then draw svg picture to display those numbers.

=head1 Version

 Author: Wenbin Liu, liuwenbin@genomics.org.cn
 Version: 1.1,  Date: 2010-06-25

=head1 Usage

 perl ellipse_venn_figure.pl <infile> [--Option]
  <infile>               input file, describe shared ortholog numbers among 4 species groups;
  --width <num>          the length of the horizontal drawing area, default=500
  --height <num>         the length of the vertical drawing area, default=500
  --flank_x <num>        the border of the horizontal drawing area, default=width/4
  --flank_y <num>        the border of the vertical drawing area, default=height/5
  --number_size <num>    the font size of gene family numbers, default=width/30
  --name_size <num>      the font size of the species names, default=width/25
  --title_size <num>     the font size of title, default=width/25
  --title <str>          the title of the figure, default="Number of gene families"
  --color <str>          the color of the ellipses (lower right, upper right, lower left, upper left)
                         default="lightseagreen,cornflowerblue,orange,lightcoral"
  --help                 show help information
 
=head1 Example

 perl ellipse_venn_figure.pl U.mar_venn_table > ellipse.svg
 
=cut

## Revised by Wang Zhuo, wangzhuo@genomics.org.cn
## 2010-09-30

use strict;
use SVG;
use Getopt::Long;
my ($height, $width, $flank_x, $flank_y, $number_size, $name_size, $title, $color, $help);
GetOptions(
    "height:i"      => \$height,
    "width:i"       => \$width,
    "flank_x:i"     => \$flank_x,
    "flank_y:i"     => \$flank_y,
    "number_size:i" => \$number_size,
    "name_size:i"   => \$name_size,
    "title:s"       => \$title,
    "color:s"       => \$color,
    "help"          => \$help
);
die `pod2text $0` if (@ARGV != 1);

# Draw svg picture displaying shared ortholog numbers;
$height  ||= 450;
$width   ||= 450;
$flank_x ||= $width / 3;
$flank_y ||= $height / 5;
my $pwidth  = $width + 2 * $flank_x;
my $pheight = $height + 3 * $flank_y;
$number_size ||= $width / 30;
$name_size   ||= $width / 25;
my $w1 = "http://www.w3.org/2000/svg";
my $w2 = "http://www.w3.org/1999/xlink";
my $svg = SVG->new(width => $pwidth, height => $pheight, xmlns => $w1, "xmlns:xlink" => $w2);

### Draw ellipses;
$color ||= "lightseagreen,cornflowerblue,orange,lightcoral";
my @colours = split /,/, $color;
my ($rx, $ry) = (0.88 * $height / 1.73 / 1.73, 0.88 * $height / 1.73);
my @translate_x = (-$rx, -1.2 * $rx, 1.2 * $rx, $rx);
my @translate_y = (0, -0.2 * $height, -0.2 * $height, 0);
my ($cx, $cy) = ($flank_x + $width / 2, $flank_y + 1.3 * $height - $ry);
my @rotate = (65, 35, -35, -65);
my ($ro_x, $ro_y) = ($cx, $flank_y + 1.2 * $height);

foreach my $i (0 .. 3) {
    my $grp = $svg->group(
        style => { 'stroke-width' => '3', 'stroke-opacity' => '1', 'fill-opacity' => '0.4' },
        transform => "rotate($rotate[$i],$ro_x,$ro_y) translate($translate_x[$i],$translate_y[$i])"
    );
    $grp->ellipse(cx => $cx, cy => $cy, rx => $rx, ry => $ry, stroke => $colours[$i], fill => $colours[$i]);
}

## Add the species names and the gene families numbers;
my $file = shift;
open IN, $file;
my @spe_name = (split /\s+/, <IN>);
my @family_num;
while (<IN>) {
    push(@family_num, (split /\s+/, $_));
}
my @number_x = (0, 0.3, 0.5, 0.75, -0.3, 0, 0.35, 0.68, -0.5, -0.35, 0, 0.6, -0.75, -0.68, -0.6);
my @number_y = (0, 0.2, 0.38, 0.68, 0.2, 0.4, 0.8, 1, 0.38, 0.8, 1.1, 1.25, 0.68, 1, 1.25);
my ($x0, $y0) = ($flank_x + $width / 2, $flank_y + $height);
foreach (0 .. 14) {
    $number_x[$_] = $x0 - $ry * $number_x[$_];
    $number_y[$_] = $y0 - $ry * $number_y[$_];
    $svg->text('x', $number_x[$_], 'y', $number_y[$_], 'stroke', 'none', 'fill', 'black', '-cdata', $family_num[$_], 'font-size', $name_size, 'text-anchor', 'middle', 'font-family', 'Arial');
}
my @name_x = (-1.15, -0.56, 1.15, 0.56);
my @name_y = (0.85,  1.7,   0.85, 1.7);
foreach (0 .. 3) {
    $name_x[$_] = $x0 - $ry * $name_x[$_];
    $name_y[$_] = $y0 - $ry * $name_y[$_];
    foreach my $per_spe_name (split /\*/, $spe_name[$_]) {
        $svg->text('x', $name_x[$_], 'y', $name_y[$_], 'stroke', 'none', 'fill', 'black', '-cdata', $per_spe_name,'font-style','italic', 'font-size', $name_size, 'text-anchor', 'middle', 'font-family', 'Arial');
        $name_y[$_] += $name_size;
    }
}
$title ||= "Number of gene families";
my $title_size ||= $width / 25;
my ($title_x, $title_y) = ($x0, $y0 + 0.17 * $height);
$svg->text('x', $title_x, 'y', $title_y, 'stroke', 'none', 'fill', 'black', '-cdata', $title, 'font-size', $title_size, 'text-anchor', 'middle', 'font-family', 'Arial');
print $svg->xmlify;

