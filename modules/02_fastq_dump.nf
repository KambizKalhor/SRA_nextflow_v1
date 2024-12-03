process FASTQ_DUMP {
    publishDir "${params.fastq_dump_results}", mode: 'copy', failOnError: true

    input:
    tuple val(sample_id), path(fastq_files)

    output:
    tuple val(sample_id), 
           path("${sample_id}/${sample_id}_1.fastq"), 
           path("${sample_id}/${sample_id}_2.fastq"),
           emit: process_FASTQ_DUMP_output

    script:
    """
    module purge
    module load gcc/8.3.0
    module load sratoolkit/2.11.0

    mkdir -p ${sample_id}
    fastq-dump --split-3 -O ${sample_id}/ ${params.raw_fastq_files}/${sample_id}/${fastq_files} || { echo "Failed to do fastq-dump"; exit 1; }
    
    # it is wierd that my names are SRR7066495.fastq_1.fastq and i have to rename them
    mv ${sample_id}/${sample_id}.fastq_1.fastq ${sample_id}/${sample_id}_1.fastq
    mv ${sample_id}/${sample_id}.fastq_2.fastq ${sample_id}/${sample_id}_2.fastq
    """

}
