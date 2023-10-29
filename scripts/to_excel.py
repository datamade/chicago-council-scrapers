import sys
from pathlib import Path
import pandas as pd

with pd.ExcelWriter(sys.argv[-1]) as writer:
    for csvfilename in sys.argv[1:-1]:
        p = Path(csvfilename)
        sheet_name = p.stem[:31]
        df = pd.read_csv(p)
        df.to_excel(writer, sheet_name=sheet_name)
