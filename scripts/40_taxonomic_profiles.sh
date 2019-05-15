#!/bin/bash

#usage: ./40_taxonomic_profiles.sh path_to_contigs.fa path_to_centrifuge_db out_dir
#make sure you have the database for centrifuge indexed. Softwares needed:
#centrifuge

contigs=$1
db=$2
out_dir=$3

cd $out_dir
mkdir -p taxonomic_profiles
cd taxonomic_profiles


#For assembly
centrifuge -f -x $db -U $contigs \
	    --report-file taxonomy.tsv \
		       -S taxonomy 2> centrifuge.log


#generating kraken style reports for visualization in pavian
centrifuge-kreport -x $db taxonomy.tsv > krakenreport 2> krakenreport.log
