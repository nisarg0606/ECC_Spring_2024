import sys
from collections import defaultdict
from operator import itemgetter

hourly_ip_count = defaultdict(int)

# Accept user input for hour range
start_hour, end_hour = map(int, sys.argv[1].split('-'))

for line in sys.stdin:
    line = line.strip()
    hour, ip, count = line.split('\t', 2)
    count = int(count)

    # Extract the hour from the timestamp
    hour_int = int(hour[-2:])
    
    # Check if the hour falls within the user-defined range
    if start_hour <= hour_int < end_hour:
        hourly_ip_count[ip] += count

# Sort IP addresses based on their counts
sorted_ips = sorted(hourly_ip_count.items(), key=itemgetter(1), reverse=True)[:3]

# Output the top 3 IP addresses for the specified hour range
print(f"Top 3 IP addresses from {start_hour:02}:00:00 to {(end_hour-1):02}:59:59:")
for ip, count in sorted_ips:
    print(f"    IP: {ip}, Count: {count}")
