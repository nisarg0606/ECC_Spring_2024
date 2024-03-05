#!/usr/bin/env python3

import sys
from operator import itemgetter
from collections import defaultdict
import os

# Get the timeframe from the environment variable
timeframe = os.environ.get('TIMEFRAME')
if timeframe:
    start_hour, end_hour = map(int, timeframe.split('-'))

# Create a dictionary to store the count of each IP
ip_count = defaultdict(int)

# Read input lines from standard input
for line in sys.stdin:
    line = line.strip()
    # Split the line into hour, IP, and count
    hour, ip, count = line.split('\t', 2)
    # Convert hour and count to integer
    hour = int(hour.split()[1])
    count = int(count)
    # Check if the hour is within the specified timeframe
    if start_hour <= hour < end_hour:
        # Update the count of the IP
        ip_count[ip] += count

# Sort IP addresses based on their counts
sorted_ips = sorted(ip_count.items(), key=itemgetter(1), reverse=True)

# Output the top 3 IP addresses for the specified timeframe
top_3_ips = sorted_ips[:3]
print(f"Top 3 IP addresses from {start_hour:02}:00:00 to {(end_hour-1):02}:59:59 are as follows:")
for ip, count in top_3_ips:
    print(f"IP: {ip}, Count: {count}")
