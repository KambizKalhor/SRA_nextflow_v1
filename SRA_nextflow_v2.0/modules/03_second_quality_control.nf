process SECOND_QC {
    publishDir "${params.second_quality_control_results}", mode: 'copy', failOnError: true

    input:
    tuple val(sample_id),
          path("${params.trimmomatic_results}/${sample_id}/${sample_id}_TRIMMED_REVERSE_PAIRED_R2.fastq"),
          path("${params.trimmomatic_results}/${sample_id}/${sample_id}_TRIMMED_FORWARD_PAIRED_R1.fastq")

    output:
    tuple val(sample_id),
          path("${sample_id}/${sample_id}_TRIMMED_REVERSE_PAIRED_R2_fastqc.html"),
          path("${sample_id}/${sample_id}_TRIMMED_REVERSE_PAIRED_R2_fastqc.zip"),
          path("${sample_id}/${sample_id}_TRIMMED_FORWARD_PAIRED_R1_fastqc.html"),
          path("${sample_id}/${sample_id}_TRIMMED_FORWARD_PAIRED_R1_fastqc.zip"),
          emit: process_SECOND_QC_output

    script:
    """
    module load gcc/11.3.0
    module load fastqc/0.11.9

    mkdir -p ${sample_id}
    fastqc -t $task.cpus -o ${sample_id}/ ${params.trimmomatic_results}/${sample_id}/${sample_id}_TRIMMED_FORWARD_PAIRED_R1.fastq ${params.trimmomatic_results}/${sample_id}/${sample_id}_TRIMMED_REVERSE_PAIRED_R2.fastq
    """
}

