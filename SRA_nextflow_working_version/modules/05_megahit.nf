process MEGAHIT {
    publishDir "${params.megahit_results}", mode: 'copy', failOnError: true

    input:
    tuple val(sample_id),
          path("${params.trimmomatic_results}/${sample_id}/${sample_id}_TRIMMED_FORWARD_PAIRED_R1.fastq"),
          path("${params.trimmomatic_results}/${sample_id}/${sample_id}_TRIMMED_REVERSE_PAIRED_R2.fastq")

    output:
    tuple val(sample_id),
          path("${sample_id}/final.contigs.fa"),
          emit: process_MEGAHIT_final_contig_output

    tuple val(sample_id),
          path("${sample_id}/log"),
          path("${sample_id}/options.json"),
          path("${sample_id}/checkpoints.txt"),
          path("${sample_id}/done"),
          path("${sample_id}/intermediate_contigs", type: 'dir'),
          emit: process_all_MEGAHIT_output

    script:
    """
    module purge
    eval "\$(conda shell.bash hook)"
    conda activate megahit_env

    megahit --presets meta-large -1 ${params.trimmomatic_results}/${sample_id}/${sample_id}_TRIMMED_FORWARD_PAIRED_R1.fastq -2 ${params.trimmomatic_results}/${sample_id}/${sample_id}_TRIMMED_REVERSE_PAIRED_R2.fastq -o ${sample_id}/
    """
}

