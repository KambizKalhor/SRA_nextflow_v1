#!/bin/bash
#SBATCH --account=asteen_1130
#SBATCH --partition=main
#SBATCH --cpus-per-task=8
#SBATCH --mem=64G
#SBATCH --nodes=2
#SBATCH --time=01:00:00


export JAVA_HOME=/home1/kkalhor/important_basic_files/java/jdk-11
export PATH=$JAVA_HOME/bin:$PATH
source ~/.bashrc
java -version
module load nextflow


nextflow run workflow.nf -resume -c nextfolw_slurm_configs.config
