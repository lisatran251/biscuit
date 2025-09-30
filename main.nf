nextflow.enable.dsl=2

include { PREPROCESSING } from './workflows/preprocessing.nf'

params.reads_glob = "assets/data/*_{R1,R2}.fastq.gz"
params.ref = "assets/ref/test_ref.fa"


workflow {    
    reads = Channel
              .fromFilePairs(params.reads_glob)
              .map { id, files -> tuple([id:id], files) }

    reference = Channel.of( tuple([id:'genome'], file(params.ref)) )

    PREPROCESSING(reads, reference)

}
