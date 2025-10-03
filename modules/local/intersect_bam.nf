process BEDTOOLS_INTERSECT_BAM {
    tag "$meta.id"
    label 'process_medium'

    conda "bioconda::bedtools=2.31.1 bioconda::samtools=1.20"

    input:
    tuple val(meta), path(bam), path(index)
    path bed

    output:
    tuple val(meta), path("${meta.id}.blremoved.bam"), path("${meta.id}.blremoved.bam.bai"), emit: bam

    publishDir "results/${meta.id}/intersect", mode: 'copy'    

    script:
    """
    bedtools intersect -v -abam $bam -b $bed > ${meta.id}.blremoved.bam
    samtools index -@ $task.cpus ${meta.id}.blremoved.bam
    """
}
