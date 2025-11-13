process TRANSFER_GZ_FILES {
    publishDir "${params.gz_files}", mode: 'copy', failOnError: true

    input:
    tuple val(sample_id), path(zip_file)

    output:
    tuple val(sample_id), path("${sample_id}/${zip_file.name}"), emit: process_TRANSFER_GZ_FILES_output

    script:
    """
    mkdir -p ${sample_id}
    cp -v ${zip_file} ${sample_id}/ || { echo "Failed to copy file"; exit 1; }
    """

    stub:
    """
    mkdir -p ${sample_id}
    touch ${sample_id}/${zip_file.name}
    """
}
