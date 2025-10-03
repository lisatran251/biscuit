process FILTER_VALID_CONTIGS {
    tag "${meta.id}"

    input:
    tuple val(meta), path(bam)    
    tuple val(meta2), path(contigs)  

    output:
    tuple val(meta), path("${meta.id}.filtered.bam"), path("${meta.id}.filtered.bam.csi"), emit: bam

    script:
    """
    samtools view -h $bam \
      | awk 'BEGIN{while((getline < "${contigs}")>0) keep[\$1]=1} \
             /^@SQ/ {split(\$2,a,":"); if(keep[a[2]]) print; next} \
             /^@/ {print; next} \
             {if(keep[\$3]) print}' \
      | samtools view -b -o ${meta.id}.filtered.tmp.bam -

    samtools sort -o ${meta.id}.filtered.bam ${meta.id}.filtered.tmp.bam
    samtools index -c ${meta.id}.filtered.bam
    """
}

