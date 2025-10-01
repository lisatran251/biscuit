nextflow.enable.dsl=2

include { PREPROCESSING   } from './workflows/preprocessing.nf'
include { VARIANT_CALLING } from './workflows/variant_calling.nf'


params.reads_glob = "assets/data/*_{R1,R2}.fastq.gz"
params.ref        = "assets/ref/test_ref.fa"
params.mask_bed   = "assets/ref/mask_union.hg38.bed"  // required here

workflow {
    reads = Channel
              .fromFilePairs(params.reads_glob)
              .map { id, files -> tuple([id:id], files) }

    reference = Channel.of( tuple([id:'genome'], file(params.ref)) )

    pre = PREPROCESSING(reads, reference)

    VARIANT_CALLING(pre.markdup_bams, reference, pre.index, Channel.of(file(params.mask_bed)))

}
