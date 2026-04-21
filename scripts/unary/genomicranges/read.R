source("lib/helpers.R")
source("scripts/reading/genomicranges.R")

files <- get_unary_arguments()

annotations <- read_genomic_file(files$annotation_file)

capture.output(print(length(annotations)), file = files$outfile)