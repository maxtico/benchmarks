import time

from lib.helpers import get_files, write_result

start = time.time()
annotations, reads = get_files("pyranges_0")
print(time.time() - start, "reading")

start = time.time()
df = annotations.subtract(reads, strandedness=False)
print(time.time() - start, "overlaps")

start = time.time()
write_result("binary", str(len(df)))
print(time.time() - start)
