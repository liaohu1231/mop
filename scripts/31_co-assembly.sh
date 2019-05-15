#!/bin/bash

#usage: ./co-assembly.sh path_to_mG_forward.fastq path_to_mG_reverse.fastq path_to_mT_forward.fastq path_to_mT_reverse.fastq out_dir
#Make sure before running this script the following softwares are installed.
#cd-hit
#idba

mG_forward=$1
mG_reverse=$2
mT_forward=$3
mT_reverse=$4
out_dir=$5

cd $out_dir
mkdir -p co-assembly
cd co-assembly


#STEP1:merge trimmed and filetered reads from mT and mG
cat $mG_forward $mT_forward > merged-1.fastq
cat $mG_reverse $mT_reverse > merged-2.fastq

#STEP2:remove redundant reads from the merged data using cd-hit
cd-hit-dup -i merged-1.fastq -i2 merged-2.fastq \
             -o final-merged-1.fastq -o2 final-merged-2.fastq > cd_hit_dup.log

#STEP3:assemble paired reads using idba-ud
#merge paired-end reads and convert fastq format to fasta  
fq2fa --merge --filter final-merged-1.fastq final-merged-2.fastq final-merged.fa > fq2fa.log

#assmbly using idba_ud
mkdir -p final_assembly
idba_ud -r final-merged.fa -o final_assembly > idba_ud.log
