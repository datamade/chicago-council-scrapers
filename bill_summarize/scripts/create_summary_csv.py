import csv
import pathlib
import sys
import json

writer = csv.DictWriter(sys.stdout, fieldnames=["filename", "summary"])
writer.writeheader()

for summary_file in pathlib.Path("summaries").glob("*.summary"):
    with summary_file.open() as f:
        summary_dict = json.load(f)
    row = {"filename": summary_file.stem, "summary": summary_dict["summary"]}
    writer.writerow(row)
