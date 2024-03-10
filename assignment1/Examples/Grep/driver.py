#!/usr/bin/env python3

'''
author: Nisarg Shah
email: ns26@iu.edu
Subject: ENGR-E 516
Assignment: 1
Grep driver
'''

import subprocess

input_file = "F://ECC_Spring_2024//Assignment_01//Input//example.log"
output_file = "assignment1//Part_01//Outputs_New"

# Run the first MapReduce job to count occurrences of IP addresses per hour
mapper1_cmd = ["python3", "mapper.py"]
reducer1_cmd = ["python3", "reducer.py"]
sort_cmd = ["sort"]

with open(input_file, 'r') as f:
    p1 = subprocess.Popen(mapper1_cmd, stdin=f, stdout=subprocess.PIPE)
    p2 = subprocess.Popen(sort_cmd, stdin=p1.stdout, stdout=subprocess.PIPE)
    p3 = subprocess.Popen(reducer1_cmd, stdin=p2.stdout)

p3.wait()
