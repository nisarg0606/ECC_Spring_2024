#!/usr/bin/env python3

import sys
import re
from datetime import datetime

# Regular expression pattern to match IP addresses and timestamps
log_pattern = re.compile(r'(?P<ip>\d+\.\d+\.\d+\.\d+) .* \[(?P<timestamp>[^\]]+)\]')

for line in sys.stdin:
    match = log_pattern.search(line.strip())
    if match:
        ip = match.group('ip')
        timestamp_str = match.group('timestamp').split()[0]  # Extracting date from timestamp
        try:
            timestamp = datetime.strptime(timestamp_str, "%d/%b/%Y:%H:%M:%S")
            hour = timestamp.strftime("%H")
            print(f"{hour}\t{ip}\t1")  # Emitting hour, IP, and count
        except ValueError:
            pass
