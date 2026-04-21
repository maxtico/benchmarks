import sys
import bioframe as bf
import pandas as pd
import numpy as np

from lib.helpers import write_result

input_file = sys.argv[1]
df = bf.read_table(
    input_file,
    schema="bed3",
    dtype={"chrom": str, "start": np.int64, "end": np.int64},
)

write_result("unary", str(len(df)))