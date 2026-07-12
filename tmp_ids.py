import re
from collections import Counter
ids=[]
with open('lib/data/campus_data.dart') as f:
    for line in f:
        line=line.strip()
        if line.startswith("id:"):
            match=re.search(r"id:\s*'([^']+)'", line)
            if match:
                ids.append(match.group(1))
dups={k: v for k, v in Counter(ids).items() if v > 1}
print('duplicates', dups)
print('total ids', len(ids))
