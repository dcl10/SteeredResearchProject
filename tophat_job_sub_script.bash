#!/usr/bin/bash
#
#PBS -N #*JOB NAME HERE*#
#PBS -l walltime=08:00:00 #Vary walltime according to input file size, testing revealed 2 4GB read sets takes ~3 hours, 2 12GB sets ~8 hours
#PBS -l nodes=1:ppn=8 #8 nodes gets decent scheduling on HPC, approximately 1-2 hours of runtime can't be hyperthreaded so increased nodes get diminishing returns
#PBS -l vmem=32gb #Relates to the number of nodes, more nodes need more memory.
#PBS -m bea
#PBS -M *****@le.ac.uk

#Runs Tophat and cufflinks without annotation on the HPC. This script uses manual submission but might be adapted for automation.

#Loads the necessary programs for the job to run
module load tophat/3.3.6
module load cufflinks/2.2.1
module load bowtie2/2.2.9

export OMP_NUM_THREADS=$PBS_NUM_PPN #

tophat2 -p 8 -o /scratch/spectre/*/*****/tophat_results_#*SAMPLE NAME*# -r 160 -g 10 -G /scratch/spectre/*/*****/#*DIR CONTAINING GENOMES*#/#*GENOME NAME*#.gtf /scratch/spectre/*/*****/#*DIR CONTAINING GENOMES*#/#*GENOME*# /scratch/spectre/*/*****/#*SAMPLE 1*#.fastq /scratch/spectre/*/*****/#*SAMPLE 2*#.fastq
cufflinks -p 8 -o /scratch/spectre/*/*****/tophat_results_#*SAMPLE NAME*# /scratch/spectre/*/*****/tophat_results_#*SAMPLE NAME*#/accepted_hits.bam
Contact GitHub API Training Shop Blog About

