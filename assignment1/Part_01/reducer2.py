#!/usr/bin/env python3

import sys
from operator import itemgetter
from collections import defaultdict

# Dictionary to store IP addresses and their counts
ip_counts = defaultdict(int)

# Read input from stdin
for line in sys.stdin:
    line = line.strip()
    # Split the line by tab character
    hour, ip, count = line.split('\t', 2)
    # Convert count to integer
    count = int(count)
    # Increment the count for the IP address
    ip_counts[ip] += count

# Sort IP addresses by count in descending order
sorted_ips = sorted(ip_counts.items(), key=itemgetter(1), reverse=True)

# Output the top 3 IP addresses along with their counts
for ip, count in sorted_ips[:3]:
    print(f"IP: {ip}, Count: {count}")