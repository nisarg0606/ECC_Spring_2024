#!/bin/bash

# Define HDFS input and output paths
hdfs_input="/assignment01/input/access.log"
#keep the output directory dynamic
hdfs_output="/assignment01/part1/output/$(date +%s)"

# Check if the output directory exists, delete it if it does
hdfs dfs -test -d $hdfs_output
if [ $? -eq 0 ]; then
    echo "Deleting existing output directory: $hdfs_output"
    hdfs dfs -rm -r $hdfs_output
fi

# Run the Hadoop streaming job
hadoop jar $HADOOP_HOME/share/hadoop/tools/lib/hadoop-streaming-3.3.6.jar \
    -file /home/hadoop/assignment01/part1/mapper2.py \
    -mapper "/usr/bin/python3 /home/hadoop/assignment01/part1/mapper2.py" \
    -file /home/hadoop/assignment01/part1/reducer2.py \
    -reducer "/usr/bin/python3 /home/hadoop/assignment01/part1/reducer2.py" \
    -input $hdfs_input \
    -output $hdfs_output

echo "Job completed. Output stored in: $hdfs_output"
