#!/usr/bin/env python3

'''
author: Nisarg Shah
email: ns26@iu.edu
Subject: ENGR-E 516
Assignment: 1
grep reducer
'''

import sys

# Input comes from standard input (stdin)
for line in sys.stdin:
    # Remove leading and trailing whitespace
    line = line.strip()
    print(line)
