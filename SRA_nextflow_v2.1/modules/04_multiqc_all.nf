// Define the process for running MultiQC_AFTER
process MULTIQC_All {
    publishDir "${params.multiqc_reports_alltogether}", mode: 'copy'

    input:
    path '*'

    output:
    path 'multiqc_report.html'
    path 'multiqc_data'

    script:
    """
    module purge
    eval "\$(conda shell.bash hook)"
    conda activate multiqc_env

    multiqc .
    """
}
