process FIRST_QC {
    publishDir "${params.first_quality_control_results}", mode: 'copy', failOnError: true

    input:
    tuple val(sample_id), path(reads)

    output:
    path (sample_id)

    script:
    """
    module load gcc/11.3.0
    module load fastqc/0.11.9

    mkdir -p ${sample_id}
    fastqc -t $task.cpus -o ${sample_id} -f fastq -q ${reads}
    """
}

