process UNZIP_FILES {
    publishDir "${params.raw_fastq_files}", mode: 'copy', failOnError: true

    input:
    tuple val(sample_id), path(fastq_gz)

    output:
    tuple val(sample_id), path("${sample_id}/${sample_id}.fastq"), emit: process_UNZIP_FILES_outputs

    script:
    """
    mkdir -p ${sample_id}
    gunzip -c ${fastq_gz} > ${sample_id}/${sample_id}.fastq || { echo "Failed to unzip to raw_fastq_files"; exit 1; }
    """

    stub:
    """
    mkdir -p ${sample_id}
    touch ${sample_id}/${sample_id}.fastq
    """
}

