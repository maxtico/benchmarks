Introduction
============

Benchmark the speed and memory footprint of common genomic-interval operations across several libraries (Python's bioframe and pyranges; R's GenomicRanges; and bash's bedtools).

The workflow:

1. Grabs real data describing the size of sequences (human genome, human protein)
2. Creates synthetic BED files of varying sizes so that run-time can be swept over
many problem sizes.
3. Runs the same operation with every library and measures wall-clock time, and peak resident memory (RSS)
4. Collects all benchmarks into a single CSV.

The JSON and tabular files in this repo define the range of dataset parameters to be tested, as well as which operations are tested.

The code under the folder scripts/ defines how each operation is implemented for each library.

Installation
============

Python packages
~~~~~~~~~~~~~~~
Assuming mamba is installed, do:

mamba create -yn bench python
mamba activate bench

pip install snakemake
pip install pyranges1 bioframe

Now test:

python -c 'import bioframe; import pyranges'

R packages
~~~~~~~~~~

You can use 'rig' to manage R versions. R in conda/mamba gives plenty of problems.
Now open R (4.5.1):

R

Then paste (best if one-by-one):

if (!require("BiocManager", quietly = TRUE))
    install.packages("BiocManager")
BiocManager::install(version='devel')
BiocManager::install("rtracklayer")
BiocManager::install("GenomicRanges")
BiocManager::install("GenomeInfoDb")

And test, also in R:

library(GenomicRanges)
library(rtracklayer)
library(GenomeInfoDb)

Bedtools
~~~~~~~~

Assuming Linux Ubuntu or similar, paste on the command-line:

sudo apt-get install bedtools

Usage
=====

1) Run all the benchmarks:

nohup snakemake -j 1 --benchmark-extended  --cores 1 &> snakemake.log

Results are found in ../results/collected_results.csv
But they lack a status flag clarifying whether it worked or not, so:

2) Collect and add status:

python add_status_column.py ../results/collected_results.csv snakemake.log collected_results.with_status.csv

3) Plot results:

Open plot_benchmark_results.Rmd in Rstudio and run it.
The code assumes that three collected_results.with_status.csv files were generated, corresponding the three different replicates.
These are provided in this repo under the collected_results/ folder.
Their filename is defined in the first lines.


Notes on the different behavior of methods/operations in different libraries
============================================================================
Intersect:
- the name of this operation may be misleading. All libraries are performing just a filter on the input "annotation" intervals that overlap with the "reads" intervals.

Find nearest interval:
- Overlaps: GenomicRanges does not allow you to ignore the overlapping intervals. The other libraries ignore overlaps.
- Ties: Bioframe does not get all ties (nearest at same distance), and instead it only keeps one. 
- k-nearest: In the benchmark, Bioframe, Pyranges, and BEDTools are requested to get the two nearest intervals per interval, but GenomicRanges cannot; thus, GenomicRanges only finds the single nearest interval.
