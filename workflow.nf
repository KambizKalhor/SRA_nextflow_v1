#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

// Parameter definitions with defaults
params.input_dir = "$projectDir/inputs"
params.gz_files = "$projectDir/results/00_gz_input_files"
params.raw_fastq_files = "$projectDir/results/01_fastq_raw_files"
params.fastq_dump_results = "$projectDir/results/02_fastq_dump_results"
params.first_quality_control_results = "$projectDir/results/03_first_quality_control_results"
params.trimmomatic_results = "$projectDir/results/04_trimmomatic_results"
params.second_quality_control_results = "$projectDir/results/05_second_quality_control_results"
params.metaspades_results = "$projectDir/results/06_metaspade_results"

params.metaquast_results = "$projectDir/results/07_metaquast_results"
params.metaquast_executable = "/home1/kkalhor/important_basic_files/metaQuast/quast-5.2.0/metaquast.py"


log.info """
         FASTQ Processing Pipeline
         =========================
         input_dir    : ${params.input_dir}
         gz_files : ${params.gz_files}
         raw_fastq_files : ${params.raw_fastq_files}
         """
         .stripIndent()

// Import processes
include { TRANSFER_GZ_FILES } from './modules/00_transfer_gz_files.nf'
include { UNZIP_FILES } from './modules/01_unzipping_to_have_raw_fasq_files.nf'
include { FASTQ_DUMP } from './modules/02_fastq_dump.nf'
include { FIRST_QC } from './modules/03_first_quality_control.nf'
include { TRIMMOMATIC } from './modules/04_trimmomatic.nf'
include { SECOND_QC } from './modules/05_second_quality_control.nf'
include { METASPADES } from './modules/06_metaspades.nf'
include { METAQUAST } from './modules/07_metaquast.nf'

workflow {
    // Create a channel from input files
    input_files = Channel
        .fromPath("${params.input_dir}/*.fastq.gz", checkIfExists: true)
        .ifEmpty { error "No .fastq.gz files found in ${params.input_dir}" }
        .map { file -> tuple(file.simpleName, file) }

    // Transfer files
    TRANSFER_GZ_FILES(input_files)

    // Unzip files
    UNZIP_FILES(TRANSFER_GZ_FILES.out.process_TRANSFER_GZ_FILES_output)

    // doing fastq-dump
    FASTQ_DUMP(UNZIP_FILES.out.process_UNZIP_FILES_outputs)


    // first quality control step
    FIRST_QC (FASTQ_DUMP.out.process_FASTQ_DUMP_output)


    // trimmomatic
    TRIMMOMATIC(FASTQ_DUMP.out.process_FASTQ_DUMP_output)


    // second quality control step
    SECOND_QC(TRIMMOMATIC.out.process_groupA_TRIMMOMATIC_output)


    // metaspades
    METASPADES(TRIMMOMATIC.out.process_groupA_TRIMMOMATIC_output)


    // metaquast
    METAQUAST(METASPADES.out.process_scaffold_fasta_METASPADES_output)

}

workflow.onComplete {
    log.info "Pipeline completed at: $workflow.complete"
    log.info "Execution status: ${ workflow.success ? 'OK' : 'failed' }"
}
