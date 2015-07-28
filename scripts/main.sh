# 
# This pipeline was written for identifying olfactory receptor genes.
#
# Usage:
#	bash main.sh <genome.fa> <ORs.fa> <num_threads>
#
#
set -eu
set -o pipefail

# Parameters
GENOME=$1
OR_GENEs=$2
NUM_THREADS=$3

# DIRs and files
SCRIPTS_DIR="../../scripts/"
OUTPUT_DIR="./"
TMP_SUFFIX="-tmp"
BLAST_DB="${OUTPUT_DIR}$(basename $GENOME '.fa')"
BLAST_OUT="${OUTPUT_DIR}$(basename $OR_GENEs '.fa')2$(basename $GENOME '.fa').tblastn"
BLAST_OUT_GFF="${OUTPUT_DIR}blast-out.gff"
BLAST_OUT_SORTED="${OUTPUT_DIR}blast-out-sorted.gff"
CLUSTERS="${OUTPUT_DIR}cluster.gff"
CLUSTERS_SORTED="${OUTPUT_DIR}clusters-sorted.gff"

BEST_HITS="${OUTPUT_DIR}best-hits.gff"
# Critera
HITS_LEN_GT_250="${OUTPUT_DIR}hits-len-gt-250.gff"

# ================================================================================================================================
# Blast:
# First, we perform homology search with OR genes against the target genome.
# If blast results are not exist, we perform blasting.
if [ ! -e $BLAST_OUT ];then
	#echo "Start blasting..."
	# Make blast database for blast.
	makeblastdb -dbtype nucl -in $GENOME -title "reference genome database" -parse_seqids -out $BLAST_DB

	# tblastn search
	tblastn -db $BLAST_DB -query $OR_GENEs -out "${OUTPUT_DIR}${BLAST_OUT}_tmp" -evalue 1e-20 -outfmt 6 -num_threads $NUM_THREADS
	mv "${OUTPUT_DIR}${BLAST_OUT}_tmp" $BLAST_OUT

	# Remove database
	find "$OUTPUT_DIR" -name "$(basename $BLAST_DB).n*" | xargs -n 1 rm -I
fi

# ================================================================================================================================
# Get best hits:


# Best hits.
if [ ! -e $BEST_HITS ];then
	# Blast 2 GFF
	if [ ! -e $BLAST_OUT_GFF ];then
		bash "${SCRIPTS_DIR}blast2gff.sh" $BLAST_OUT > "${BLAST_OUT_GFF}${TMP_SUFFIX}"
		mv "${BLAST_OUT_GFF}${TMP_SUFFIX}" $BLAST_OUT_GFF
	fi

	# Sort GFF file by strand then chromosome, start
	if [ ! -e $BLAST_OUT_SORTED ];then
		cat $BLAST_OUT_GFF | sort -k7,7 -k1,1 -k4n,4 > "${BLAST_OUT_SORTED}${TMP_SUFFIX}"
		mv "${BLAST_OUT_SORTED}${TMP_SUFFIX}" $BLAST_OUT_SORTED
	fi
	# Clustering
	# Ouch! the hits was sorted by chromosome then start using linux sort! No other workarounds.
	if [ ! -e $CLUSTERS ];then
		bedtools cluster -i $BLAST_OUT_SORTED > "${CLUSTERS}${TMP_SUFFIX}"
		mv "${CLUSTERS}${TMP_SUFFIX}" $CLUSTERS
	fi
	# After clustered the hits, sort the cluster by cluster ID then e-value, bit score
	# Now, the first hit in a cluster is the best one.
	# Paste the bit score to the last column, then sort, and get the best hits.
	if [ ! -e $CLUSTERS_SORTED ];then
		paste <(cat $CLUSTERS) <(cat $CLUSTERS | cut -f 9 | cut -f 8 -d ';' | cut -f 2 -d '=') \
		| sort -k10n,10 -k6g,6 -k11gr,11 > "${CLUSTERS_SORTED}${TMP_SUFFIX}"
		mv "${CLUSTERS_SORTED}${TMP_SUFFIX}" $CLUSTERS_SORTED
	fi
	# Get best hits
	if [ ! -e $BEST_HITS ];then	
		cat $CLUSTERS_SORTED | awk -v OFS='\t' '{ if (( $10!=last )) { last=$10; print $1,$2,$3,$4,$5,$6,$7,$8,$9 } }' \
		> "${BEST_HITS}${TMP_SUFFIX}"
		mv "${BEST_HITS}${TMP_SUFFIX}" $BEST_HITS
	fi
fi

# Remove intermediate files
#find "$OUTPUT_DIR" -name "$(basename $BLAST_OUT_GFF)" -o -name "$(basename $BLAST_OUT_SORTED)" \
#-o -name "$(basename $CLUSTERS)" -o -name "$(basename $CLUSTERS_SORTED)" | xargs -n 1 rm -I

# ================================================================================================================================
# Critera 1: discard hits which length is shorter than 250 aa.
#
#
if [ ! -e $HITS_LEN_GT_250 ];then
	cat $BEST_HITS | awk '($5-$4+1)/3>=250{ print $0 }' > $HITS_LEN_GT_250
fi

# ================================================================================================================================
# Critera 2: 



# ================================================================================================================================






