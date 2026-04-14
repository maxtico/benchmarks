
source("lib/helpers.R")
source("scripts/reading/genomicranges.R")

files <- get_binary_arguments()

annotations <- read_genomic_file(files$annotation_file)
reads <- read_genomic_file(files$read_file)


common_seqlevels <- intersect(seqlevels(reads), seqlevels(annotations))
reads <- keepSeqlevels(reads, common_seqlevels, pruning.mode = "coarse")
annotations <- keepSeqlevels(annotations, common_seqlevels, pruning.mode = "coarse")

hits <- GenomicRanges::countOverlaps(annotations, reads, ignore.strand = TRUE)

# Get the left side with duplicates if multiple overlaps occur
# queryHits(hits) returns the indices of gr1 that overlap gr2
annotations$score <- hits
result <- annotations


capture.output(print(result), file = files$outfile)
