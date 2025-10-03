process BISCUIT_PILEUP {
    tag "$meta.id"
    label 'process_medium'

    conda "bioconda::biscuit=1.7.1"
    container "quay.io/biocontainers/biscuit:1.7.1.20250908--hc4b60c0_0"

    input:
    tuple val(meta), path(bam), path(bai)
    tuple val(meta2), path(fasta)
    tuple val(meta3), path(index)

    output:
    tuple val(meta), path("${meta.id}.vcf"), emit: vcf
    path "versions.yml", emit: versions

    publishDir "results/${meta.id}/pileup", mode: 'copy'

    script:
    def cpus = task.cpus
    def prefix = meta.id

    """
    # link fasta into index directory (for biscuit)
    ln -sf \$(readlink $fasta) $index/$fasta

    biscuit pileup \\
        -N \\
        -@ $cpus \\
        -o ${prefix}.vcf \\
        $index/$fasta \\
        $bam

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        biscuit: \$(biscuit version |& sed '1!d; s/^.*BISCUIT Version: //' )
    END_VERSIONS
    """
}
