from lib.helpers import get_file, write_result
import pyranges1 as pr

df = get_file("pyranges")
print(df)

df = df.cluster_overlaps()

write_result("unary", str(df))