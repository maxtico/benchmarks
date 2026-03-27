from pathlib import Path

import numpy as np
import pandas as pd
import pyranges as pr
from pyranges import PyRanges


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
    gr = pr.PyRanges(df)
    print(gr)
    return gr
