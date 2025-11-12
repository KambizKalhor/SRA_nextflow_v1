#!/bin/bash
#SBATCH --account=asteen_1130
#SBATCH --partition=main
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --nodes=1
#SBATCH --time=01:00:00



params.multiqc_reports_before_trimmomatic=$1
params.multiqc_reports_after_trimmomatic=$2
params.multiqc_reports_alltogether=$3

cp -r $params.multiqc_reports_before_trimmomatic ${params.multiqc_reports_alltogether}/
cp -r $params.multiqc_reports_after_trimmomatic ${params.multiqc_reports_alltogether}/
module purge
eval "\$(conda shell.bash hook)"
conda activate multiqc_env
multiqc ${params.multiqc_reports_alltogether}
