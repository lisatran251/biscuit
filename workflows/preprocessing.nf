nextflow.enable.dsl=2

include { BISCUIT_INDEX }   from '../modules/nf-core/biscuit/index/main.nf'
include { BISCUIT_ALIGN }   from '../modules/nf-core/biscuit/align/main.nf'
include { SAMTOOLS_MARKDUP } from '../modules/local/markdup.nf'
include { CREATE_VALID_CONTIGS       } from '../modules/local/create_valid_contigs.nf'


workflow PREPROCESSING {
    take:
    reads        // (meta, [R1,R2])
    reference    // (meta, fasta)

    main:
        CREATE_VALID_CONTIGS(reference)
        BISCUIT_INDEX(reference)
        BISCUIT_ALIGN(reads, reference, BISCUIT_INDEX.out.index)
        SAMTOOLS_MARKDUP(BISCUIT_ALIGN.out.bam)

    emit:
        index        = BISCUIT_INDEX.out.index
        contigs      = CREATE_VALID_CONTIGS.out.contigs
        markdup_bams = SAMTOOLS_MARKDUP.out.bam
        markdup_bais = SAMTOOLS_MARKDUP.out.bai
}
