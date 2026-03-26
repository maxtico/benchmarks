
import numpy as np

rule generate_file:
    input:
        chromsizes = "data/chromsizes/{genome}.tsv"
    output:
        "{DOWNLOAD_DIR}/generated/{filetype}/{genome}/{nrows}/{maxlength}.bed"
    run:
        import pyranges1 as pr
        import pandas as pd
        rows = int(wildcards.nrows)
        maxlength = int(wildcards.maxlength)
        print("rows", rows)
        print("maxlength", maxlength)

        chroms = pd.read_table(input.chromsizes, header=0)
        print(chroms)

        print(1)
        df = pr.random(rows, strand=False, chromsizes=chroms, length=1)
        print(2)
        df.End += np.random.randint(maxlength, size=rows)

        print(3)
        df.to_csv(output[0], index=False, sep="\t", header=False)