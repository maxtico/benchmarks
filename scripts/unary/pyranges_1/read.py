import sys
import pyranges1 as pr

from lib.helpers import write_result

input_file = sys.argv[1]
df = pr.read_bed(input_file)

write_result("unary", str(len(df)))