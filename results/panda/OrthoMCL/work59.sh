orthomclLoadBlast /home/DATA/db/orthomcl/orthomcl.config.template similarSequences7.txt
orthomclPairs /home/DATA/db/orthomcl/orthomcl.config.template orthomcl_pairs7.log  cleanup=no
orthomclDumpPairsFiles /home/DATA/db/orthomcl/orthomcl.config.template
mcl mclInput  --abc -I 1.5 -o mclOutput
orthomclMclToGroups fam 1 < mclOutput > or_groups.txt
