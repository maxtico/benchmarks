from pathlib import Path

import polars as pl
import polars_bio as pb


def read(
    f: Path,
) -> pl.LazyFrame:
    df = pb.scan_table(
        str(f),
        schema="bed3",
        # Overrides target pre-BED parser column names; final columns are still
        # emitted as chrom/start/end by the bed3 schema.
        schema_overrides={
            "column_1": pl.String,
            "column_2": pl.Int32,
            "column_3": pl.Int32,
        },
    )
    df.config_meta.set(coordinate_system_zero_based=True)
    print(df.collect_schema())
    return df
