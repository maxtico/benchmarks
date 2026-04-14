import sys
import pyranges1 as pr

from lib.helpers import write_result

input_file = sys.argv[1]
df = pr.read_bed(input_file)

df = df.cluster_overlaps()

write_result("unary", str(df))