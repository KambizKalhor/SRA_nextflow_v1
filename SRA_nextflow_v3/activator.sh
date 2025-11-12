#!/bin/bash
#SBATCH --account=asteen_1130
#SBATCH --partition=debug
#SBATCH --cpus-per-task=8
#SBATCH --mem=8G
#SBATCH --nodes=1
#SBATCH --time=1:00:00


export JAVA_HOME=/home1/kkalhor/important_basic_files/java/jdk-11
export PATH=$JAVA_HOME/bin:$PATH
source ~/.bashrc
java -version
module load nextflow


nextflow run workflow.nf -resume -c nextfolw_slurm_configs.config
