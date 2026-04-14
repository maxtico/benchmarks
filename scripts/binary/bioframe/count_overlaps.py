import bioframe as bf
import pandas as pd

from lib.helpers import get_files, write_result

annotations, reads = get_files("bioframe")

df: pd.DataFrame = bf.count_overlaps(annotations, reads)

write_result("binary", str(len(df)))
