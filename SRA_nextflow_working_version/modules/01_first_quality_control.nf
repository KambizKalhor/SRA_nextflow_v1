process FIRST_QC {
    publishDir "${params.first_quality_control_results}", mode: 'copy', failOnError: true

    input:
    tuple val(sample_id), path(reads)

    output:
    path (sample_id)

    script:
    """
    module load gcc
    module load fastqc

    mkdir -p ${sample_id}
    fastqc -t $task.cpus -o ${sample_id} -f fastq -q ${reads}
    """
}


