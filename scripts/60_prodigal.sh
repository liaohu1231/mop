#!/bin/bash

assembly_contig=$1
output_dir=$2
scripts="$(dirname "$output_dir")"
home="$(dirname "$scripts")"

#prediction with PRODIGAL
: '-------------------------------------------------------------------------------------------------------------------------'
cd $output_dir
mkdir -p prodigal
cd prodigal

#run prodigal to get gbk and protein predictions
prodigal -i $assembly_contig -o coassembly_gene_p.gbk -a coassembly_protein_p.fasta -p meta 2> prodigal.log
sed -i 's/\*//g' coassembly_protein_p.fasta
: '-------------------------------------------------------------------------------------------------------------------------'

#protein annotation with pfam HMMER3
: '-------------------------------------------------------------------------------------------------------------------------'
cd ..
mkdir -p hmmer
cd hmmer

hmmsearch --tblout pfam_hmmer.out --cpu 8 $home/databases/hmmer_dbs/Pfam-A.hmm.gz  \
          ../prodigal/coassembly_protein_p.fasta > hmmer.log

: '-------------------------------------------------------------------------------------------------------------------------'



#commands to build the database for protein identification from metaproteomics
: '-------------------------------------------------------------------------------------------------------------------------'
cd ..
mkdir -p protein_db
cd protein_db

grep -v "^#" ../hmmer/pfam_hmmer.out | awk '{OFS=","}{print $1,$3,$4,$5}' | sort > contigs
sed -i '1s/^/contig_name,prot_name,accession,e-value\n/' contigs

python /groups/ALS5224/GBCB5874_2019/multiomics/scripts/build_proteindb.py contigs ../prodigal/coassembly_protein_p.fasta \
       mp_protein_db.fasta 

rm contigs
: '-------------------------------------------------------------------------------------------------------------------------'
