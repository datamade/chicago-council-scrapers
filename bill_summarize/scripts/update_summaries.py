import sys
import csv

original_file = sys.argv[1]
second_file = sys.argv[2]

updated_files = set()
with open(original_file) as f:
    reader = csv.DictReader(f)
    for row in reader:
        updated_files.add(row["filename"])

writer = csv.DictWriter(sys.stdout, fieldnames=["filename", "summary"])
writer.writeheader()
with open(original_file) as f:
    reader = csv.DictReader(f)
    for row in reader:
        if row["filename"] not in updated_files:
            writer.writerow(row)

with open(second_file) as f:
    reader = csv.DictReader(f)
    writer.writerows(reader)
