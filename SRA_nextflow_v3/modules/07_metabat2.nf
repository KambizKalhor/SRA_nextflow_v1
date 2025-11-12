process METABAT2 {
    publishDir "${params.metabat2_results}", mode: 'copy', failOnError: true
    conda "bioconda::metabat2=2.15"

    input:
    tuple val(sample_id),path("${params.metaspades_results}/${sample_id}/scaffolds.fasta")
    tuple val(sample_id), path(reads)


    output:
    path "bins/*.fa", emit: bins

    script:
    """
    metabat2 -i "${params.metaspades_results}/${sample_id}/scaffolds.fasta" -o bins/bin \
        $(for r in ${reads}; do echo "-1 \$r"; done)
    """
}
