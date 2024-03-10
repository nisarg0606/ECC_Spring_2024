#!/usr/bin/env python3

'''
author: Nisarg Shah
email: ns26@iu.edu
Subject: ENGR-E 516
Assignment: 1
sort reducer
'''

import sys

# Identity reducer
for line in sys.stdin:
    # remove leading and trailing whitespace
    line = line.strip()
    # if line is empty, skip it
    if not line:
        continue
    print(line.strip())