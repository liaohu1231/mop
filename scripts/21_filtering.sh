#!/bin/bash

#make sure you have the appropriate database for this step. For metagenome use hg38 GENOME FASTA FILE as input. 
#for metatranscriptome analysis use hg38 TRANSCRIPTOME FASTA FILE (rna file) as input  
#usage: ./datafiltering.sh fastq_forward_reads_path fastq_reverse_reads_path path_to_hg38.fa output_path  

#Make sure befor using this script that Bowtie2 is loaded. Use the following script for installing if not.
#conda install bowtie2


forward_reads=$1
reverse_reads=$2
index_dir=$3
out_dir=$4
out_prefix=$5

echo "Filtering human reads..."

cd $out_dir
mkdir -p bowtie2_out
cd bowtie2_out

#filtering input reads
bowtie2 -x $index_dir \
        -1 $forward_reads \
        -2 $reverse_reads \
        -S $out_prefix'_alignments.sam'

samtools view -bS $out_prefix'_alignments.sam' > $out_prefix'_alignments.bam'
samtools view -b -f 12 -F 256 $out_prefix'_alignments.bam' > $out_prefix'_unmapped.bam'

samtools sort -n $out_prefix'_unmapped.bam' > $out_prefix'_unmapped_sorted.bam'
bedtools bamtofastq -i $out_prefix'_unmapped_sorted.bam' \
                    -fq $out_prefix'_host_removed_r1.fastq' -fq2  $out_prefix'_host_removed_r2.fastq'


echo "Done filtering"

