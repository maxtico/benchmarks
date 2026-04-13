import time
import polars_bio as pb

from lib.helpers import get_files, write_result

start = time.time()
annotations, reads = get_files("polars_bio")
print(time.time() - start, "reading")

start = time.time()
df = pb.overlap(
    annotations,
    reads,
    cols1=["chrom", "start", "end"],
    cols2=["chrom", "start", "end"],
)
print(time.time() - start, "overlaps")

start = time.time()
write_result("binary", len(df.collect()))
print(time.time() - start)
