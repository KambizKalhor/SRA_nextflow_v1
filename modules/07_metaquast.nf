process METAQUAST {
    publishDir "${params.metaquast_results}", mode: 'copy', failOnError: true

    input:
    tuple val(sample_id),
          path("${params.metaspades_results}/${sample_id}/scaffolds.fasta")

    output:
    tuple val(sample_id),
          path("${sample_id}/icarus.html"),
          path("${sample_id}/metaquast.log"),
          path("${sample_id}/report.html"),
          path("${sample_id}/combined_reference", type: 'dir'),
          path("${sample_id}/icarus_viewers", type: 'dir'),
          path("${sample_id}/krona_charts", type: 'dir'),
          path("${sample_id}/not_aligned", type: 'dir'),
          path("${sample_id}/quast_downloaded_references", type: 'dir'),
          path("${sample_id}/runs_per_reference", type: 'dir'),
          path("${sample_id}/summary", type: 'dir'),
          emit: process_METAQUAST_output

    script:
    """
    mkdir -p ${sample_id}
    ${params.metaquast_executable} ${params.metaspades_results}/${sample_id}/scaffolds.fasta -o ${sample_id}/    
    """
}

