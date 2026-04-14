from pathlib import Path

import numpy as np
import pandas as pd


def read(
    f: Path,
) -> pd.DataFrame:
    df = pd.read_csv(
        f,
        header=None,
        names=["chrom", "start", "end"],
        sep="\t",
        dtype={"chrom": str, "start": np.int32, "end": np.int32},
    )
    df.attrs["coordinate_system_zero_based"] = True
    print(df.dtypes)
    return df
