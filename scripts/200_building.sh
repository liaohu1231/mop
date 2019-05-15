#!/bin/bash

#make sure you have the appropriate database for this step. For metagenome use hg38 GENOME FASTA FILE as input. 
#for metatranscriptome analysis use hg38 TRANSCRIPTOME FASTA FILE (rna file) as input  
#usage: ./datafiltering.sh fastq_forward_reads_path fastq_reverse_reads_path path_to_hg38.fa output_path  

#Make sure befor using this script that Bowtie2 is loaded. Use the following script for installing if not.
#conda install bowtie2

hg38=$1
out_dir=$2

db_name=$(basename $hg38)
db_index="${db_name%.*}"_index

echo "Building the hg38 index..."
cd $out_dir
mkdir -p $db_index
cd $db_index

#building index file for hg38
bowtie2-build $hg38 $db_index
echo "Done building the index!"
