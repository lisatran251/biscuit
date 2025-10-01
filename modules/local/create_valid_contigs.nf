process CREATE_VALID_CONTIGS {
    tag "$meta.id"
    label 'process_short'

    conda "bioconda::samtools=1.20"
    container "quay.io/biocontainers/samtools:1.20--h50ea8bc_1"

    input:
    tuple val(meta), path(fasta)

    output:
    tuple val(meta), path("valid_contigs.txt"), emit: contigs

    script:
    """
    # index FASTA if not already done
    samtools faidx $fasta

    # extract valid contig names
    cut -f1 ${fasta}.fai > valid_contigs.txt
    """
}
