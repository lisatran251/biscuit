process ALIGN {
    tag "$sample"
    label 'process_medium'

    conda "bioconda::biscuit=1.7.1 bioconda::samtools=1.20"
    container "quay.io/biocontainers/biscuit:1.7.1.20250908--hc4b60c0_0"

    input:
    tuple val(sample), path(r1), path(r2)
    path ref_dir

    output:
    tuple val(sample), path("${sample}.aln.sam"), emit: sam
    path "versions.yml", emit: versions
    
    script:
    """
    ref=\$(find $ref_dir -name '*.fa')

    biscuit align -@ ${task.cpus} -b 0 \\
      -R '@RG\\tLB:lib1\\tID:run1\\tPL:ILLUMINA\\tPU:unit1\\tSM:${sample}' \\
      \$ref $r1 $r2 > ${sample}.aln.sam 2> ${sample}.align.log

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        biscuit: \$(biscuit --version 2>&1 | head -n 1)
        samtools: \$(samtools --version 2>&1 | head -n 1 | awk '{print \$2}')
    END_VERSIONS
    """
}
