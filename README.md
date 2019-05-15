# MoP
Pipeline to integrate and process metagenomics(mG), metatranscriptomics(mT), and metaproteomics(mP) dataset

### **Introduction**
MoP is a pipeline that integrates metagenomics, metatranscriptomics and metaproteomics data and uses all datasets to obtain a broader set of useful and insightful information from the samples. This information can be further used to answer biologically relevant questions related to the data. 

### **Commands to install dependencies through anaconda**
```
Trimmomatic: conda install -c bioconda trimmomatic
Bowtie2: conda install -c bioconda bowtie2 
CD-HIT: conda install -c bioconda cd-hit 
CD-HIT-DUP: conda install -c bioconda cd-hit-auxtools
IDBA: conda install -c bioconda idba
Centrifuge: conda install -c bioconda centrifuge
Prodigal: conda install -c bioconda prodigal
Hmmer3: conda install -c biocore hmmer
MSGF+: conda install -c bioconda msgf_plus
Samtools: conda install -c bioconda samtools
Bedtools: conda install -c bioconda bedtools 
Metabat2: conda install -c ursky metabat2 
```
### **What is needed?**

- Raw or quality and host filtered PAIRED-END metagenomics and metatranscriptomics read files
- Metaproteomics file in mzML format 

*Note: this pipeline will only work with PAIRED-END metagenomic and metatranscriptomic reads. The metaproteomic file needs to be in mzML format (msconvert from proteowizardtools with peakpicking is recommended for converting from raw to mzML)*

- Host genome/transcriptome placed in the Databases directory
- Index database for Centrifuge in the Databases directory

### **How to run?**

$ git clone https://github.com/mop-multi-omics-pipeline/mop.git
$ cd scripts

###### There are two options to run the pipeline: from raw files use '-a' or from files that have been quality and host genome filtered use '-p'

###### Provide FULL paths for every argument; contig size min allowed is 1500

$ ./MoP_pipeline.sh mG-forward mG-reverse mT-forward mT-reverse mP-mzML mG-hostread-db mT-hostread-db \
                    centrifuge-db out-dir [-a/-p] contig-min-size

### **Output**
- Host reads
- Host-free reads
- Taxonomic profiles
- Contig bins
- Predicted ORFs and protein sequences
- Protein database with pfam identifiers (fasta)
- Protein families identified from metaproteomics samples

