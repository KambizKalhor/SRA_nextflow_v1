// Define the process for running MultiQC_BEFORE
process MULTIQC_BEFORE {
    publishDir "${params.multiqc_reports_before_trimmomatic}", mode: 'copy'

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
