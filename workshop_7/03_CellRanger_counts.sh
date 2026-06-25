#!/bin/bash
#SBATCH --partition=main
#SBATCH --requeue
#SBATCH --job-name=cellranger
#SBATCH --ntasks=1
#SBATCH --array=1-2
#SBATCH --cpus-per-task=16
#SBATCH --mem-per-cpu=8000
#SBATCH --time=9:01:00
#SBATCH --output=cellranger.log.txt

module use /projects/community/modulefiles
module load cellranger

WORK_DIR="/scratch/$USER/bmihai_ws7"

# path to fastq files
FASTQPATH="$WORK_DIR/fastq"

# get sample to process
INPUT=($(ls -d $FASTQPATH/*R1_001.fastq.gz))

SAMPLE_NAME=($(echo ${INPUT[$SLURM_ARRAY_TASK_ID]##*/} | cut -d_ -f1-1))

# path to reference library
REFPATH="$WORK_DIR/cellranger-ref/refdata-gex-GRCh38-2024-A/"

# CellRanger creates the output folder in the current directory, so
# we will move to the appropriate folder
OUT_DIR="$WORK_DIR/cellranger-out"
mkdir -p $OUT_DIR

cd $OUT_DIR

cmd="cellranger count --id=$SAMPLE_NAME \
   --create-bam=true \
   --sample=$SAMPLE_NAME \
   --fastqs=$FASTQPATH \
   --localcores=$SLURM_CPUS_PER_TASK \
   --localmem=124 \
   --transcriptome=$REFPATH"
echo "Running - $cmd"
$cmd

