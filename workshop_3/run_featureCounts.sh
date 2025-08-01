#!/bin/bash

featureCounts -g gene_name -t gene -O --fraction -T 32  \
  -a /projects/community/classes/bmihai_camp/STAR_index_human/gencode.v47.primary_assembly.annotation.gtf \
  -o /scratch/$USER/hivtb_data/counts_table.txt \
  $(printf "%s " /scratch/$USER/hivtb_data/aligned/*.sorted.bam)