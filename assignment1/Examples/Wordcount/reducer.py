#!/usr/bin/env python3

import sys

current_word = None
current_count = 0

for line in sys.stdin:
    # Remove leading and trailing whitespace
    line = line.strip()

    # Split the line into word and count
    word, count = line.split('\t', 1)

    try:
        count = int(count)
    except ValueError:
        continue

    # Update count, if current_word is the same as word
    if current_word == word:
        current_count += count
    else:
        # If it is a new word, output previous word & count
        if current_word:
            print(f"{current_word}\t{current_count}")
       
        # Update current word & count
        current_word = word
        current_count = count

# Output the last word & count
if current_word:
    print(f"{current_word}\t{current_count}")