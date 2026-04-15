import polars_bio as pb

from lib.helpers import get_file, write_result

df = get_file("polars_bio")

df = pb.merge(
    df,
    cols=["chrom", "start", "end"],
)

write_result("unary", str(len(df.collect())))