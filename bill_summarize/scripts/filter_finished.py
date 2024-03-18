import sys
import csv
import pathlib

completed_summaries_file = sys.argv[1]

completed_files = set()

with open(completed_summaries_file) as f:
    reader = csv.DictReader(f)
    for row in reader:
        completed_files.add(row["filename"])

reader = csv.DictReader(sys.stdin)

writer = csv.DictWriter(sys.stdout, fieldnames=reader.fieldnames)
writer.writeheader()

for row in reader:
    url = pathlib.Path(row["url"])
    if url.name not in completed_files:
        writer.writerow(row)
