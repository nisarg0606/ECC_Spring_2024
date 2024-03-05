import re
import sys

pat = re.compile(r'(?P<ip>\d+\.\d+\.\d+\.\d+).?\w+(?P<subdir>.)')

for line in sys.stdin:
    match = pat.search(line.strip())
    if match:
        print(f"{match.group('ip')}\t{1}")
