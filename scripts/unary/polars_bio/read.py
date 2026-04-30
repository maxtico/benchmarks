import sys
from pathlib import Path

from lib.helpers import write_result
from scripts.reading.polars_bio import read

input_file = sys.argv[1]
df = read(Path(input_file))

write_result("unary", str(df.collect().height))
