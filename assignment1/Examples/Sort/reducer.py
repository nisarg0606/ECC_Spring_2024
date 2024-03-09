#!/usr/bin/env python3

import sys

# Identity reducer
for line in sys.stdin:
    # remove leading and trailing whitespace
    line = line.strip()
    # if line is empty, skip it
    if not line:
        continue
    print(line.strip())