#!/bin/bash
#SBATCH --partition=main
#SBATCH --requeue
#SBATCH --job-name=seq-dl
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=8000
#SBATCH --time=3:01:00
#SBATCH --output=sc-dl.log.txt

# safely make the workshop 7 directory in scratch, and make a 
# subdirectory for storing fastq files
FASTQ_DIR="/scratch/$USER/bmihai_ws7/fastq/"
mkdir -p $FASTQ_DIR

# load sratoolkit to be able to download from SRA
module use /projects/community/modulefiles
module load sratoolkit

# download the gzipped fastq files using fastq-dump
fastq-dump --gzip --split-files --outdir $FASTQ_DIR SRR11038995
fastq-dump --gzip --split-files --outdir $FASTQ_DIR SRR11038991
