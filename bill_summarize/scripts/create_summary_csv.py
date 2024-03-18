import csv
import pathlib
import sys

writer = csv.DictWriter(sys.stdout, fieldnames=["filename", "summary"])
writer.writeheader()

for summary_file in pathlib.Path("summaries").glob("*.summary"):
    summary = summary_file.open().read().strip()
    if summary != "TEXT IS EMPTY":
        row = {"filename": summary_file.stem, "summary": summary}
        writer.writerow(row)
