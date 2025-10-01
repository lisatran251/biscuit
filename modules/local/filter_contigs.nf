process FILTER_VALID_CONTIGS {
    tag "$meta.id"
    label 'process_medium'

    conda "bioconda::samtools=1.20"
    container "quay.io/biocontainers/samtools:1.20--h50ea8bc_1"

    input:
    tuple val(meta), path(bam), path(bai)
    tuple val(meta2), path(contigs)

    output:
    tuple val(meta), path("${meta.id}.filtered.bam"), path("${meta.id}.filtered.bam.bai"), emit: bam

    script:
    """
    samtools view -h $bam \\
      | awk 'BEGIN{while((getline < "$contigs")>0) keep[\$1]=1} \\
             /^@SQ/ {split(\$2,a,":"); if(keep[a[2]]) print; next} \\
             /^@/ {print; next} \\
             {if(keep[\$3]) print}' \\
      | samtools view -b -o ${meta.id}.filtered.bam

    samtools index -@ $task.cpus ${meta.id}.filtered.bam
    """
}
