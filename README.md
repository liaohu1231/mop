# mop
Pipeline to integrate and process metagenomics, metatranscriptomics, and metaproteomics dataset

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

### **How to run?**
*Note: this pipeline will only work with PAIRED-END metagenomic and metatranscriptomic reads. The metaproteomic file needs to be in mzML format (msconvert from proteowizardtools with peakpicking is recommended for converting from raw to mzML)*

### **Output**
