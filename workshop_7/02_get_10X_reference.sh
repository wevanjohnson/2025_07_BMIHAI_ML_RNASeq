#!/bin/bash
#SBATCH --partition=main
#SBATCH --requeue
#SBATCH --job-name=ref-dl
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=8000
#SBATCH --time=1:00:00
#SBATCH --output=10X-ref-dl.log.txt

WORK_DIR="/scratch/$USER/bmihai_ws7"
REF_DIR="$WORK_DIR/cellranger-ref"

# safely make and enter the "cellranger-ref" folder to store index
mkdir -p $REF_DIR
cd $REF_DIR

# download pre-built CellRanger reference from 10X genomics
wget "https://cf.10xgenomics.com/supp/cell-exp/refdata-gex-GRCh38-2024-A.tar.gz"

# decompress and unpack the reference
tar -xvzf refdata-gex-GRCh38-2024-A.tar.gz
