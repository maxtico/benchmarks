import time

from lib.helpers import get_files, write_result

start = time.time()
annotations, reads = get_files("pyranges_0")
print(time.time() - start, "reading")

start = time.time()
df = annotations.overlap(reads, strand_behavior="ignore", multiple="all")
print(time.time() - start, "overlaps")

start = time.time()
write_result("binary", str(len(df)))
print(time.time() - start)
