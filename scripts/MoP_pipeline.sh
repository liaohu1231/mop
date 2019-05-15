#!/bin/bash

mg_fwd=$1
mg_rev=$2
mt_fwd=$3
mt_rev=$4
mp_mzml=$5
mg_hg_db=$6
mt_hg_db=$7
centrifuge_db=$8
out_dir=$9
steps_2run="${10}"
contig_size="${11}"

mg_basename=$(basename $mg_hg_db)
mg_index="${mg_basename%.*}"_index
mt_basename=$(basename $mt_hg_db)
mt_index="${mt_basename%.*}"_index


#Check number of args given is correct
: '-------------------------------------------------------------------------------------------------------'
if [ $# -ne 11 ]; then
   echo "Usage: ./MoP_pipeline.sh mGfwd mGrev mTfwd mTrev mPmzml mg_hgdb mt_hgdb centrifuge_db out_dir [-a/-p] contig_size"
   exit
fi
: '-------------------------------------------------------------------------------------------------------'

#Check files exist
: '-------------------------------------------------------------------------------------------------------'
if [ ! -f $mg_fwd ]; then
   echo "$mg_fwd does not exist"
   exit
elif [ ! -f $mg_rev ]; then
   echo "$mg_rev does not exist"
   exit
elif [ ! -f $mt_fwd ]; then
   echo "$mt_rev does not exist"
   exit
elif [ ! -f $mt_rev ]; then
   echo "$mt_rev does not exist"
   exit
elif [ ! -f $mp_mzml ]; then
   echo "$mp_mzml does not exist"
   exit
fi
: '-------------------------------------------------------------------------------------------------------'

#Check contig size is an int
: '-------------------------------------------------------------------------------------------------------'
re='^[0-9]+$'
if ! [[ $contig_size =~ $re ]]; then
   echo "error: $contig_size is NOT a number"
   exit
elif [ $contig_size -lt 1500 ]; then
   echo "contig size needs to be >= 1500"
   exit
fi
: '-------------------------------------------------------------------------------------------------------'

#Run the steps according to the user's selection -a->all -p->go straight to co-assembly
: '-------------------------------------------------------------------------------------------------------'
case "$steps_2run" in
-a) echo "MoP is filtering your files with trimmomatic ..................................................."
./10_trimmomatic.sh $mg_fwd $mg_rev $out_dir mg
./10_trimmomatic.sh $mt_fwd $mt_rev $out_dir mt

echo "MoP is building the index of your host databases ..................................................."
./200_building.sh $mg_hg_db $out_dir
./200_building.sh $mt_hg_db $out_dir

echo "MoP is getting rid of host reads ..................................................................."
./21_filtering.sh $out_dir/trimmomatic_out/mg1_paired.fq.gz $out_dir/trimmomatic_out/mg2_paired.fq.gz \
                  $out_dir/$mg_index/$mg_index $out_dir mg 
./21_filtering.sh $out_dir/trimmomatic_out/mt1_paired.fq.gz $out_dir/trimmomatic_out/mt2_paired.fq.gz \
                  $out_dir/$mt_index/$mt_index $out_dir mt

echo "MoP co-assembling your metagenome/transcriptome datasets ..........................................."
./31_co-assembly.sh $out_dir/bowtie2_out/mg_host_removed_r1.fastq $out_dir/bowtie2_out/mg_host_removed_r2.fastq \
                    $out_dir/bowtie2_out/mt_host_removed_r1.fastq $out_dir/bowtie2_out/mt_host_removed_r2.fastq \
                    $out_dir

echo "MoP is getting taxonomic profiles from co-assembled contigs  ......................................."
./40_taxonomic_profiles.sh $out_dir/co-assembly/final_assembly/contig.fa $centrifuge_db $out_dir

echo "MoP is binning the final contigs ..................................................................."
./50_metabat2.sh $out_dir/co-assembly/final_assembly/contig.fa $out_dir/co-assembly/final-merged-1.fastq \
                 $out_dir/co-assembly/final-merged-2.fastq $contig_size $out_dir

echo "MoP is predicting ORFs and proteins and annotating proteins ........................................"
./60_prodigal.sh $out_dir/co-assembly/final_assembly/contig.fa $out_dir

echo "MoP is doing protein family identification from metaproteomics  ...................................."
./70_msgf.sh $mp_mzml $out_dir/protein_db/mp_protein_db.fasta $out_dir

echo "MoP is DONE!! Bye :)"
;;
-p) echo "MoP co-assembling your metagenome/transcriptome datasets ......................................."
./31_co-assembly.sh $out_dir/bowtie2_out/mg_host_removed_r1.fastq $out_dir/bowtie2_out/mg_host_removed_r2.fastq \
                    $out_dir/bowtie2_out/mt_host_removed_r1.fastq $out_dir/bowtie2_out/mt_host_removed_r2.fastq \
                    $out_dir

echo "MoP is getting taxonomic profiles from co-assembled contigs  ......................................."
./40_taxonomic_profiles.sh $out_dir/co-assembly/final_assembly/contig.fa $centrifuge_db $out_dir

echo "MoP is binning the final contigs ..................................................................."
./50_metabat2.sh $out_dir/co-assembly/final_assembly/contig.fa $out_dir/co-assembly/final-merged-1.fastq \
                 $out_dir/co-assembly/final-merged-2.fastq $contig_size $out_dir

echo "MoP is predicting ORFs and proteins and annotating proteins ........................................"
./60_prodigal.sh $out_dir/co-assembly/final_assembly/contig.fa $out_dir

echo "MoP is doing protein family identification from metaproteomics  ...................................."
./70_msgf.sh $mp_mzml $out_dir/protein_db/mp_protein_db.fasta $out_dir

echo "MoP is DONE!! Bye :)"

;;
esac 

#end of script
: '-------------------------------------------------------------------------------------------------------'
