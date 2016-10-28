#orthomclAdjustFasta ail panda_intact.fa 1
#orthomclFilterFasta compliantFasta/ 100 20
#makeblastdb -dbtype prot -in goodProteins.fasta
#blastp -outfmt 6 -db goodProteins.fasta -query goodProteins.fasta -out all_v_all.blastp.tab -num_threads 20
#orthomclBlastParser all_v_all.blastp.tab compliantFasta/ >> similarSequences7.txt
# clean
rm -rf pairs
rm mclInput
rm mclOutput
rm orthomcl_pairs7.log
rm groups.txt
# reset database before run orthomcl
cd /home/wujiao/data/mzdl/24.genefam/0.data/
bash reset_orth.sh
cd /home/zuoyi/project/zuoyi/panda/orthomcl
orthomclLoadBlast /home/DATA/db/orthomcl/orthomcl.config.template similarSequences7.txt
orthomclPairs /home/DATA/db/orthomcl/orthomcl.config.template orthomcl_pairs7.log  cleanup=no
orthomclDumpPairsFiles /home/DATA/db/orthomcl/orthomcl.config.template
mcl mclInput  --abc -I 1.5 -o mclOutput 
orthomclMclToGroups fam 1 < mclOutput > groups.txt
