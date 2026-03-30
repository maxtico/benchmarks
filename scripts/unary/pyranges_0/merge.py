import pyranges as pr

from lib.helpers import get_file, write_result

df = get_file("pyranges_0")
print(df)

df = df.merge()

write_result("unary", str(df))
