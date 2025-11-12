#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

// Parameter definitions with defaults
params.input_dir = "$projectDir/inputs"



params.first_quality_control_results = "$projectDir/results/01_first_quality_control_results"
params.trimmomatic_results = "$projectDir/results/02_trimmomatic_results"
params.second_quality_control_results = "$projectDir/results/03_second_quality_control_results"
params.multiqc_reports_before_trimmomatic = "$projectDir/results/04_multiqc_reports/1_first_multiqc_report"
params.multiqc_reports_after_trimmomatic = "$projectDir/results/04_multiqc_reports/2_second_multiqc_report"
params.metaspades_results = "$projectDir/results/05_metaspade_results"


params.metaquast_results = "$projectDir/results/06_metaquast_results"
params.metaquast_executable = "/home1/kkalhor/important_basic_files/metaQuast/quast-5.2.0/metaquast.py"


params.metabat2_results="$projectDir/results/07_metabat2_results"

log.info """
         FASTQ Processing Pipeline
         =========================
         input_dir    : ${params.input_dir}
         """
         .stripIndent()

// Import processes
include { FIRST_QC } from './modules/01_first_quality_control.nf'
include { TRIMMOMATIC } from './modules/02_trimmomatic.nf'
include { SECOND_QC } from './modules/03_second_quality_control.nf'
include { MULTIQC_BEFORE } from './modules/04_multiqc_before.nf'
include { MULTIQC_AFTER } from './modules/04_multiqc_after.nf'
include { METASPADES } from './modules/05_metaspades.nf'
include { METAQUAST } from './modules/06_metaquast.nf'
include { METABAT2 } from './modules/07_metabat2.nf'

workflow {
    // Create a channel from input files
    input_files = Channel.fromFilePairs("${params.input_dir}/*_R{1,2}.fastq", checkIfExists: true)


    // first quality control step
    FIRST_QC (input_files)

    // running multiqc on first quality control results
    MULTIQC_BEFORE (FIRST_QC.out.collect())

    // trimmomatic
    TRIMMOMATIC(input_files)


    // second quality control step
    SECOND_QC(TRIMMOMATIC.out.process_groupA_TRIMMOMATIC_output)


    // running multiqc on first quality control results
    MULTIQC_AFTER (SECOND_QC.out.collect())


    // metaspades
    METASPADES(TRIMMOMATIC.out.process_groupA_TRIMMOMATIC_output)


    // metaquast
    METAQUAST(METASPADES.out.process_scaffold_fasta_METASPADES_output)


    // using metabat2 to bin
    METABAT2(METASPADES.out.process_scaffold_fasta_METASPADES_output, input_files)

}

workflow.onComplete {
    log.info "Pipeline completed at: $workflow.complete"
    log.info "Execution status: ${ workflow.success ? 'OK' : 'failed' }"

    // Run a shell script after completion
    //if (workflow.success) {
    //    log.info "Running final scripts"
    //    "bash something".execute().waitFor()}
}


