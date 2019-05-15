#!/bin/bash

#usage: ./50_metabat2.sh assembled_contig.fa sam_file min_contig_sz out_dir > 50_metabat.log
#./50_metabat2.sh ../data/co-assembly/assembly/contig.fa ../data/co-assembly/final-merged-1.fastq 
#                 ../data/co-assembly/final-merged-2.fastq 2500 try_indx > out
contig_file=$1
forward_reads=$2
reverse_reads=$3
contig_size=$4
out_dir=$5

#variables for bowtie2
index_dir=$out_dir/assembly_index
metabat_dir=$out_dir/metabat_out
binning_dir=$metabat_dir/$contig_size

mkdir -p $index_dir
mkdir -p $metabat_dir
mkdir -p $binning_dir

#need to create an index for sam files; create sam files w/bowtie2
#bowtie2-build $contig_file $index_dir/assembly_indx
bowtie2 -x $index_dir/assembly_indx -1 $forward_reads \
        -2 $reverse_reads -S $metabat_dir/mt_mg.sam

#create the sorted bam file
samtools view -bS $metabat_dir/mt_mg.sam > $metabat_dir/mt_mg.bam
samtools sort $metabat_dir/mt_mg.bam > $metabat_dir/mt_mg.sorted.bam
rm $metabat_dir/mt_mg.bam

#runs metabat for binning
metabat -m $contig_size -i $contig_file $metabat_dir/mt_mg.sorted.bam -o $binning_dir/mt_mg_$contig_size > $metabat_dir/binning.log
