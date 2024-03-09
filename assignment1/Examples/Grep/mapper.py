#!/usr/bin/env python3

import sys

# Get the pattern to search for from command line argument
pattern = sys.argv[1]

# Input comes from standard input (stdin)
for line in sys.stdin:
    # Remove leading and trailing whitespace
    line = line.strip()
    # Check if the line contains the pattern
    if pattern in line:
        # Emit the line to the output
        print(line)
