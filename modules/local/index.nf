process BISCUIT_INDEX {
    tag "$ref.baseName"
    label 'process_medium'

    conda "bioconda::biscuit=1.7.1"
    container "quay.io/biocontainers/biscuit:1.7.1.20250908--hc4b60c0_0"

    input:
    path ref

    output:
    path "ref_index", emit: ref_index
    path "versions.yml", emit: versions

    script:
    """
    mkdir ref_index
    cp $ref ref_index/
    cd ref_index
    refname=\$(basename $ref)
    biscuit index \$refname

    cat <<-END_VERSIONS > ../versions.yml
    "${task.process}":
        biscuit: \$(biscuit --version 2>&1 | head -n 1)
    END_VERSIONS
    """
}
