#!/bin/bash

#usage: ./trimmomatic_run.sh fastq_file_forward_path fastq_file_reverse_path output_dir_path
#input files
fastq_forward=$1
fastq_reverse=$2
out_dir=$3
out_prefix=$4

curr_dir=$(pwd)
home_dir="$(dirname "$curr_dir")"

adapters_path=$home_dir/adapters

cd $out_dir
mkdir -p trimmomatic_out
cd trimmomatic_out

trimmomatic PE -phred33 $fastq_forward $fastq_reverse \
   $out_prefix'1_paired.fq.gz' $out_prefix'1_unpaired.fq.gz' \
   $out_prefix'2_paired.fq.gz' $out_prefix'2_unpaired.fq.gz' \
   ILLUMINACLIP:$adapters_path/TruSeq3-PE.fa:2:30:10 LEADING:3 \
   TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:35 > $out_prefix'_trimmomatic.log'
