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
    tuple val(meta), path("${meta.id}.markdup.bam.bai"), emit: bai
    path "versions.yml", emit: versions

    publishDir "results/${meta.id}/markdup", mode: 'copy'

    script:
    """
    samtools markdup -@ $task.cpus -T ${meta.id} $input ${meta.id}.markdup.bam
    samtools index -@ $task.cpus ${meta.id}.markdup.bam

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        samtools: \$(samtools --version | head -n 1 | awk '{print \$2}')
    END_VERSIONS
    """
}
