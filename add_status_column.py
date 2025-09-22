import json
import re
import csv
import sys
import pandas as pd
from pathlib import Path

if len(sys.argv)<4:
    print("""Usage: 
add_status_column.py collected_results.csv snakemake.log collected_results.with_status.csv

the first two arguments are inputs, the second being the full log of snakemake, and the third is the output

""")

    sys.exit(1)

csvfile = sys.argv[1]
logfile = sys.argv[2]  #"snakemake_2307.log"
outfile = sys.argv[3]
#Path("~/benchmark_pyranges/results/summary_status.csv").expanduser()

rows = []

print(f'Reading {logfile} to get status ...')
with open(logfile) as f:
    content = f.read()

# Find all JSON objects using a relaxed pattern
json_matches = re.findall(r"\{.*?\}", content, flags=re.DOTALL)

for match in json_matches:
    try:
        data = json.loads(match)

        # Determine s from the command path
        cmd = data.get("cmd", "")

        # Construct the row
        row = {
            "status": data.get("status"),
            "nrows": data.get("number_rows"),
            "library": data.get("library"),
            "maxlength": data.get('max_length'),
            "operation":data.get('operation'),
            "genome": data.get("genome"),
        }

        rows.append(row)

    except json.JSONDecodeError:
        continue  # skip malformed JSON blocks


table_status = pd.DataFrame(rows)
table_status['maxlength'] = table_status['maxlength'].astype('int')
#table_status = table_status.astype("object")
#print(table_status.info())
#print(table_status)


print(f'Reading {csvfile} to get benchmark results ...')
table_collected = pd.read_csv(csvfile, header=0)
#table_collected = table_collected.astype("object")

#print(table_collected.info())
#print(table_collected)

non_status_cols = [c for c in table_status.columns if c!='status']
print('Merging tables...')
merged = table_collected.merge(table_status, on = non_status_cols, how='left')

if len(merged)!=len(table_status) or len(merged)!=len(table_collected):
    raise Exception(f"ERROR some values are missing. len(merged):{len(merged)} len(table_status):{len(table_status)} len(table_collected):{len(table_collected)}")

merged.to_csv(outfile, index=False)

# # Write to CSV
# with open(outfile, "w", newline="") as f:
#     writer = csv.DictWriter(f, fieldnames=["status", "nrows", "library", "maxlength","operation", "genome"])
#     writer.writeheader()
#     writer.writerows(rows)

print(f"✅ Written table with {len(merged)} rows into {outfile}")

if merged.status.isna().any():
    raise Exception(f"ERROR status has some NAs!")

