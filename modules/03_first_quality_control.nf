process FIRST_QC {
    publishDir "${params.first_quality_control_results}", mode: 'copy', failOnError: true

    input:
    tuple val(sample_id),
          path("${params.fastq_dump_results}/${sample_id}/${sample_id}_1.fastq"),
          path("${params.fastq_dump_results}/${sample_id}/${sample_id}_2.fastq")

    output:
    tuple val(sample_id),
          path("${sample_id}/${sample_id}_1_fastqc.html"),
          path("${sample_id}/${sample_id}_2_fastqc.html"),
          path("${sample_id}/${sample_id}_1_fastqc.zip"),
          path("${sample_id}/${sample_id}_2_fastqc.zip"),
          emit: process_FIRST_QC_output

    script:
    """
    module load gcc/11.3.0
    module load fastqc/0.11.9

    mkdir -p ${sample_id}
    fastqc -t $SLURM_CPUS_PER_TASK -o ${sample_id}/ ${params.fastq_dump_results}/${sample_id}/${sample_id}_1.fastq ${params.fastq_dump_results}/${sample_id}/${sample_id}_2.fastq
    """
}

