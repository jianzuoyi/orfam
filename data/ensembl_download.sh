# ensembl genome downloader

# 人类    homo sapiens  
wget -P human ftp://ftp.ensembl.org/pub/release-82/fasta/homo_sapiens/dna/CHECKSUMS
wget -P human ftp://ftp.ensembl.org/pub/release-82/fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.dna.toplevel.fa.gz
wget -P human ftp://ftp.ensembl.org/pub/release-82/fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz
# 黑猩猩   pan troglodytes
wget -P chimp ftp://ftp.ensembl.org/pub/release-82/fasta/pan_troglodytes/dna/CHECKSUMS
wget -P chimp ftp://ftp.ensembl.org/pub/release-82/fasta/pan_troglodytes/dna/Pan_troglodytes.CHIMP2.1.4.dna.toplevel.fa.gz
# 大猩猩   gorilla gorilla
wget -P gorilla ftp://ftp.ensembl.org/pub/release-82/fasta/gorilla_gorilla/dna/CHECKSUMS
wget -P gorilla ftp://ftp.ensembl.org/pub/release-82/fasta/gorilla_gorilla/dna/Gorilla_gorilla.gorGor3.1.dna.toplevel.fa.gz
# 猩猩
wget -P orangutan ftp://ftp.ensembl.org/pub/release-82/fasta/pongo_abelii/dna/CHECKSUMS
wget -P orangutan ftp://ftp.ensembl.org/pub/release-82/fasta/pongo_abelii/dna/Pongo_abelii.PPYG2.dna.toplevel.fa.gz
# 恒河猴
wget -P macaque ftp://ftp.ensembl.org/pub/release-82/fasta/macaca_mulatta/dna/CHECKSUMS
wget -P macaque ftp://ftp.ensembl.org/pub/release-82/fasta/macaca_mulatta/dna/Macaca_mulatta.MMUL_1.dna.toplevel.fa.gz
# 狨猴
wget -P marmoset ftp://ftp.ensembl.org/pub/release-82/fasta/callithrix_jacchus/dna/CHECKSUMS
wget -P marmoset ftp://ftp.ensembl.org/pub/release-82/fasta/callithrix_jacchus/dna/Callithrix_jacchus.C_jacchus3.2.1.dna.toplevel.fa.gz
# 小鼠
wget -P mouse ftp://ftp.ensembl.org/pub/release-82/fasta/mus_musculus/dna/CHECKSUMS 
wget -P mouse ftp://ftp.ensembl.org/pub/release-82/fasta/mus_musculus/dna/Mus_musculus.GRCm38.dna.toplevel.fa.gz
# 大鼠
wget -P rat ftp://ftp.ensembl.org/pub/release-82/fasta/rattus_norvegicus/dna/CHECKSUMS
wget -P rat ftp://ftp.ensembl.org/pub/release-82/fasta/rattus_norvegicus/dna/Rattus_norvegicus.Rnor_6.0.dna.toplevel.fa.gz
# 豚鼠
wget -P cavia ftp://ftp.ensembl.org/pub/release-82/fasta/cavia_porcellus/dna/CHECKSUMS
wget -P cavia ftp://ftp.ensembl.org/pub/release-82/fasta/cavia_porcellus/dna/Cavia_porcellus.cavPor3.dna.toplevel.fa.gz
# 家兔
wget -P rabbit ftp://ftp.ensembl.org/pub/release-82/fasta/oryctolagus_cuniculus/dna/CHECKSUMS
wget -P rabbit ftp://ftp.ensembl.org/pub/release-82/fasta/oryctolagus_cuniculus/dna/Oryctolagus_cuniculus.OryCun2.0.dna.toplevel.fa.gz
# 狗
wget -P dog ftp://ftp.ensembl.org/pub/release-82/fasta/canis_familiaris/dna/CHECKSUMS
wget -P dog ftp://ftp.ensembl.org/pub/release-82/fasta/canis_familiaris/dna/Canis_familiaris.CanFam3.1.dna.toplevel.fa.gz
# 猫
wget -P cat ftp://ftp.ensembl.org/pub/release-82/fasta/felis_catus/dna/CHECKSUMS
wget -P cat ftp://ftp.ensembl.org/pub/release-82/fasta/felis_catus/dna/Felis_catus.Felis_catus_6.2.dna.toplevel.fa.gz
# 熊猫
wget -P panda ftp://ftp.ensembl.org/pub/release-82/fasta/ailuropoda_melanoleuca/dna/CHECKSUMS
wget -P panda ftp://ftp.ensembl.org/pub/release-82/fasta/ailuropoda_melanoleuca/dna/Ailuropoda_melanoleuca.ailMel1.dna.toplevel.fa.gz
# 猪
wget -P pig ftp://ftp.ensembl.org/pub/release-82/fasta/sus_scrofa/dna/CHECKSUMS
wget -P pig ftp://ftp.ensembl.org/pub/release-82/fasta/sus_scrofa/dna/Sus_scrofa.Sscrofa10.2.dna_sm.toplevel.fa.gz
# 牛
wget -P cattle ftp://ftp.ensembl.org/pub/release-82/fasta/bos_taurus/dna/CHECKSUMS
wget -P cattle ftp://ftp.ensembl.org/pub/release-82/fasta/bos_taurus/dna/Bos_taurus.UMD3.1.dna.toplevel.fa.gz
# 羊
wget -P sheep ftp://ftp.ensembl.org/pub/release-82/fasta/ovis_aries/dna/CHECKSUMS
wget -P sheep ftp://ftp.ensembl.org/pub/release-82/fasta/ovis_aries/dna/Ovis_aries.Oar_v3.1.dna.toplevel.fa.gz
# 羊驼
wget -P alpaca ftp://ftp.ensembl.org/pub/release-82/fasta/vicugna_pacos/dna/CHECKSUMS
wget -P alpaca ftp://ftp.ensembl.org/pub/release-82/fasta/vicugna_pacos/dna/Vicugna_pacos.vicPac1.dna.toplevel.fa.gz
# 马
wget -P horse ftp://ftp.ensembl.org/pub/release-82/fasta/equus_caballus/dna/CHECKSUMS
wget -P horse ftp://ftp.ensembl.org/pub/release-82/fasta/equus_caballus/dna/Equus_caballus.EquCab2.dna.toplevel.fa.gz

species     toplevel    primary_assembly
human       42G         3.0G
mouse       6.4G        下载中
pig         2.7G        无
cattle      2.6G        无
sheep       2.5G        无
注：无表示没有该版本

就人类的toplevel巨大，其他物种的在正常范围啊

ftp中有物种单个染色序列与非染色体序列，类似这样的：
染色体，Ovis_aries.Oar_v3.1.dna.chromosome.1.fa.gz
       Ovis_aries.Oar_v3.1.dna.chromosome.X.fa.gz
非染色体，Ovis_aries.Oar_v3.1.dna.nonchromosomal.fa.gz
这些序列加起来应该就是 primary assembly 了吧
