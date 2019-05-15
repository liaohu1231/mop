#!/bin/bash

#usage:./8_msgf.sh mzml_file db_file out_dir 

mzml_file=$1
db_file=$2
out_dir=$3

cd $out_dir
mkdir -p msgf_out
cd msgf_out

msgf_plus -s $mzml_file -d $db_file -inst 3 -t 20ppm -ti -1,2 -ntt 2 -tda 1 -o mp_proteinfams.mzid > msgf.log

#converting mzid to tsv format
msgf_plus edu.ucsd.msjava.ui.MzIDToTsv -i mp_proteinfams.mzid > mzidtotsv.log
