process TRIMMOMATIC {
    publishDir "${params.trimmomatic_results}", mode: 'copy', failOnError: true

    input:
    tuple val(sample_id),
          path("${params.fastq_dump_results}/${sample_id}/${sample_id}_1.fastq"),
          path("${params.fastq_dump_results}/${sample_id}/${sample_id}_2.fastq")

    output:
    tuple val(sample_id),
          path("${sample_id}/${sample_id}_TRIMMED_FORWARD_PAIRED_R1.fastq"),
          path("${sample_id}/${sample_id}_TRIMMED_REVERSE_PAIRED_R2.fastq"),
          emit: process_groupA_TRIMMOMATIC_output
    tuple val(sample_id),
          path("${sample_id}/${sample_id}_TRIMMED_FORWARD_UNPAIRED_R1.fastq"),
          path("${sample_id}/${sample_id}_TRIMMED_REVERSE_UNPAIRED_R2.fastq"),
          path("${sample_id}/${sample_id}_trimmomatic.log"),
          emit: process_groupB_TRIMMOMATIC_output

    script:
    """
    module load gcc/11.3.0
    module load trimmomatic/0.39

    mkdir -p ${sample_id}
    trimmomatic PE -threads $SLURM_CPUS_PER_TASK -phred33 -trimlog ${sample_id}/${sample_id}_trimmomatic.log ${params.fastq_dump_results}/${sample_id}/${sample_id}_1.fastq ${params.fastq_dump_results}/${sample_id}/${sample_id}_2.fastq ${sample_id}/${sample_id}_TRIMMED_FORWARD_PAIRED_R1.fastq ${sample_id}/${sample_id}_TRIMMED_FORWARD_UNPAIRED_R1.fastq ${sample_id}/${sample_id}_TRIMMED_REVERSE_PAIRED_R2.fastq ${sample_id}/${sample_id}_TRIMMED_REVERSE_UNPAIRED_R2.fastq LEADING:20 TRAILING:20 SLIDINGWINDOW:13:20 MINLEN:40
    """
}

