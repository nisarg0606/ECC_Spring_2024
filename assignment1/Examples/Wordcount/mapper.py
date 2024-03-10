# #!/usr/bin/env python3

'''
author: Nisarg Shah
email: ns26@iu.edu
Subject: ENGR-E 516
Assignment: 1
wordcount mapper
'''

import sys

for line in sys.stdin:
    line = line.strip()
    words = line.split()
    for word in words:
        print('%s\t%s' % (word, 1))