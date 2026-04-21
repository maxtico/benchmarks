import sys
import polars_bio as pb
import numpy as np
import pandas as pd

from lib.helpers import write_result

input_file = sys.argv[1]
df = pb.read_table(input_file)

write_result("unary", str(len(df)))