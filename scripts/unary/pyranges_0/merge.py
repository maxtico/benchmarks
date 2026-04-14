import sys
import pyranges as pr

from lib.helpers import write_result

input_file = sys.argv[1]
df = pr.read_bed(input_file)

df = df.merge()

write_result("unary", str(df))
