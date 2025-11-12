process METAQUAST {
    publishDir "${params.metaquast_results}", mode: 'copy', failOnError: true

    input:
    tuple val(sample_id),
          path("${params.metaspades_results}/${sample_id}/scaffolds.fasta")

    output:
    tuple val(sample_id),
          path("${sample_id}/"),
          emit: process_METAQUAST_output

    script:
    """
    mkdir -p ${sample_id}
    ${params.metaquast_executable} ${params.metaspades_results}/${sample_id}/scaffolds.fasta -o ${sample_id}/    
    """
}

