process SAMTOOLS_MARKDUP {
    tag "$meta.id"
    label 'process_medium'

    conda "${moduleDir}/environment.yml"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/samtools:1.22.1--h96c455f_0' :
        'biocontainers/samtools:1.22.1--h96c455f_0' }"

    input:
        tuple val(meta), path(input)

    output:
        tuple val(meta), path("${meta.id}.markdup.bam"), emit: bam

    script:
    """
    samtools markdup -@ $task.cpus -T ${meta.id} $input ${meta.id}.markdup.bam
    """
    
}