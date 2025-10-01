nextflow.enable.dsl=2

include { BEDTOOLS_INTERSECT_BAM } from '../modules/local/intersect_bam.nf'
include { BISCUIT_PILEUP        } from '../modules/local/pileup.nf'
include { TABIX_BGZIPTABIX       } from '../modules/nf-core/tabix/bgziptabix/main.nf'


workflow VARIANT_CALLING {
    take:
    bam
    reference
    index
    mask_bed

    main:

    filtered_bam = bam

    if (params.remove_blr) {
        BEDTOOLS_INTERSECT_BAM(bam, mask_bed)
        filtered_bam = BEDTOOLS_INTERSECT_BAM.out.bam
    }

    BISCUIT_PILEUP(filtered_bam, reference, index)
    TABIX_BGZIPTABIX(BISCUIT_PILEUP.out.vcf)

    emit:
    masked_bam = params.remove_blr ? BEDTOOLS_INTERSECT_BAM.out.bam : Channel.empty()
    pileups    = BISCUIT_PILEUP.out.vcf
}
