python venn_matrix.py > venn_data.txt
perl venn_table.pl --select_spe "0;1;2;3" venn_data.txt > venn_table.txt
perl ellipse_venn_figure.pl venn_table.txt > venn_graph.svg
