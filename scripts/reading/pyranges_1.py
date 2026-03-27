from pathlib import Path
import pandas as pd
import pyranges1 as pr
import numpy as np
from pyranges1 import PyRanges


def read(
    f: Path,
) -> PyRanges:
    df = pd.read_csv(
        f,
        header=None,
        names=["Chromosome", "Start", "End"],
        sep="\t",
        dtype={"Start": np.int32, "End": np.int32},
    )
    df.columns = ["Chromosome", "Start", "End"]
    print(df.dtypes)
    # df = pd.read_table(f, names=["Chromosome", "Start", "End"], header=None)
    gr = pr.PyRanges(df)
    print(gr)
    return gr
