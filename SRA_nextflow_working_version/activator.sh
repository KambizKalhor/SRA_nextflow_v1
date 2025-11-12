#!/bin/bash
#SBATCH --account=asteen_1130
#SBATCH --partition=oneweek
#SBATCH --cpus-per-task=8
#SBATCH --mem=8G
#SBATCH --nodes=1
#SBATCH --time=6-23:00:00



module purge
module load gcc/13.3.0
module load openjdk/21.0.0_35
module load nextflow/24.10.3

export JAVA_HOME=/home1/kkalhor/important_basic_files/java/jdk-11
export PATH=$JAVA_HOME/bin:$PATH
source ~/.bashrc
java -version


nextflow run workflow.nf -resume -c nextfolw_slurm_configs_with_retry_discovery.config
