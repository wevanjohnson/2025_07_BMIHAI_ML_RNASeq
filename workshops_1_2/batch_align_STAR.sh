#!/bin/bash
#SBATCH --partition=main
#SBATCH --requeue
#SBATCH --job-name=align
#SBATCH --ntasks=1
#SBATCH --array=1-33
#SBATCH --cpus-per-task=16
#SBATCH --mem-per-cpu=8000
#SBATCH --time=3:01:00
#SBATCH --output=align.log.txt

# load dependencies from community modules
module use /projects/community/modulefiles

module load STAR/2.7.5a
module load samtools/1.3.1

# set the working directory and index directory
WORK_DIR="/scratch/$USER/hivtb_data/"

INDEX="/projects/community/classes/bmihai_camp/STAR_index_human/index"

# use sed to get the SRR at the line number
# corresponding to the task ID in the array
SRRID=$(sed -n "${SLURM_ARRAY_TASK_ID}p" $WORK_DIR/SRR_Acc_List_hivtb.txt)

# safely make the aligned seq directory
# in case it doesn't already exist
mkdir -p $WORK_DIR/aligned

# run aligner
command="STAR \
    --runThreadN $(($SLURM_CPUS_PER_TASK * 2)) \
    --alignEndsType Local \
    --genomeDir $INDEX \
    --readFilesIn $WORK_DIR/fastq/$SRRID.fastq.gz \
    --outSAMtype SAM \
    --outFileNamePrefix $WORK_DIR/aligned/$SRRID."
echo $command
$command

# remove useless log files and rename the sam to not have the star suffix
rm $WORK_DIR/aligned/$SRRID.Log.out $WORK_DIR/aligned/$SRRID.Log.progress.out
mv $WORK_DIR/aligned/$SRRID.Aligned.out.sam $WORK_DIR/aligned/$SRRID.sam


# sort and index sam for featureCounts
command="samtools sort \
    -@ $(($SLURM_CPUS_PER_TASK * 2)) \
    -m $(($SLURM_MEM_PER_CPU / 2))MB
    -o $WORK_DIR/aligned/$SRRID.sorted.bam $WORK_DIR/aligned/$SRRID.sam"
echo $command
$command

command="samtools index $WORK_DIR/aligned/$SRRID.sorted.bam"
echo $command
$command