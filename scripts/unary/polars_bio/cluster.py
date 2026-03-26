import polars_bio as pb

from lib.helpers import get_file, write_result

df = get_file("polars_bio")
print(df)

df = pb.cluster(
    df,
    cols=["chrom", "start", "end"],
    output_type="pandas.DataFrame",
)

write_result("unary", str(df))
