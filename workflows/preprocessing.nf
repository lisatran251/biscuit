nextflow.enable.dsl=2

include { BISCUIT_INDEX } from '../modules/nf-core/biscuit/index/main.nf'
include { BISCUIT_ALIGN } from '../modules/nf-core/biscuit/align/main.nf'
include { SAMTOOLS_MARKDUP } from '../modules/local/markdup.nf'


workflow PREPROCESSING {
    take:
    reads        // (meta, [R1,R2])
    reference    // (meta, fasta)

    main:
        BISCUIT_INDEX(reference)
        BISCUIT_ALIGN(reads, reference, BISCUIT_INDEX.out.index)
        SAMTOOLS_MARKDUP(BISCUIT_ALIGN.out.bam)

    emit:
        index        = BISCUIT_INDEX.out.index
        markdup_bams = SAMTOOLS_MARKDUP.out.bam

}

