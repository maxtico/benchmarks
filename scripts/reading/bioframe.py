from pathlib import Path
import pandas as pd
import bioframe as bf
import numpy as np


def read(
    f: Path,
    nrows: int | None = None,
):
    df = bf.read_table(
        f,
        schema="bed3",
        nrows=nrows,
        dtype={"chrom": str, "start": np.int64, "end": np.int64},
    )

    if f.suffix == ".gtf":
        df["end"] += 1

    print(df.dtypes)

    return df
