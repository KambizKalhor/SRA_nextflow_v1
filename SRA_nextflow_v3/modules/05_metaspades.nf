process METASPADES {
    publishDir "${params.metaspades_results}", mode: 'copy', failOnError: true

    input:
    tuple val(sample_id),
          path("${params.trimmomatic_results}/${sample_id}/${sample_id}_TRIMMED_FORWARD_PAIRED_R1.fastq"),
          path("${params.trimmomatic_results}/${sample_id}/${sample_id}_TRIMMED_REVERSE_PAIRED_R2.fastq")

    output:
    tuple val(sample_id),
          path("${sample_id}/scaffolds.fasta"),
          emit: process_scaffold_fasta_METASPADES_output

    tuple val(sample_id),
          path("${sample_id}/assembly_graph.fastg"),
          path("${sample_id}/assembly_graph_with_scaffolds.gfa"),
          path("${sample_id}/before_rr.fasta"),
          path("${sample_id}/contigs.fasta"),
          path("${sample_id}/contigs.paths"),
          path("${sample_id}/dataset.info"),
          path("${sample_id}/first_pe_contigs.fasta"),
          path("${sample_id}/input_dataset.yaml"),
          path("${sample_id}/params.txt"),
          path("${sample_id}/scaffolds.fasta"),
          path("${sample_id}/scaffolds.paths"),
          path("${sample_id}/spades.log"),
          path("${sample_id}/corrected", type: 'dir'),
      	  path("${sample_id}/K21", type: 'dir'),
      	  path("${sample_id}/K33", type: 'dir'),
      	  path("${sample_id}/K55", type: 'dir'),
      	  path("${sample_id}/misc", type: 'dir'),
          path("${sample_id}/tmp", type: 'dir'),
          emit: process_all_METASPADES_output

    script:
    """
    module purge
    module load gcc/8.3.0
    module load spades/3.13.0
    
    mkdir -p ${sample_id}
    
    spades.py --meta --threads $task.cpus --memory ${task.memory.toGiga()} --pe1-1 ${params.trimmomatic_results}/${sample_id}/${sample_id}_TRIMMED_FORWARD_PAIRED_R1.fastq --pe1-2 ${params.trimmomatic_results}/${sample_id}/${sample_id}_TRIMMED_REVERSE_PAIRED_R2.fastq -o ${sample_id}/
    """
}

